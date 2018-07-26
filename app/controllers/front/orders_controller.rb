class Front::OrdersController < FrontController

	before_action :find_order, only: [:show, :edit, :update]
	before_action :get_tokens
	before_action :verify_owner, only: [:edit, :show]

	def process_order
		# Метод нужен для того, что бы при нажатии на кнопку "заказать"
		# на странице наборов мы сначала могли залогинить пользователя
		# Так как идет редирект, то данные набора сохраняем в сессии
		phone = params['phone']
    # logger.debug("Phone is: #{phone}")
    length = phone.length

    # Сохраняем для нового пользователя настройки набора в сессии
    session[:menu_id] = params['type']
    session[:quantity] = params['quantity']
    session[:people] = params['people']
    if params['dessert'] == "on"
    	session[:dessert] = true
    end

    if params['breakfast'] == 'on'
    	session[:breakfast] = true
    end

    # Метод находится в классе user.rb
    User.password_recovery_via_sms(phone)
	end

	def new
			logger.debug "Нажато на создание нового заказа"
			# logger.debug "Ошибки предыдущего сохранения: @order"
			@cu = current_user

			# Тут проверяем, какой день сегодня - (например) с четверга по воскресенье отключаем
			# Возможность заказать набор
			if Order.check_order_day(DateTime.now)
				# У нас всегда есть пользователь, потому что мы всегда попадаем
				# на страницу new через авторизацию
				session[:phone] = @cu.phone
				
				logger.debug "Out of order called with phone: #{session[:phone]}"
				
				redirect_to out_of_order_path
				# Оповещаем админа сайта, что есть заказ в день, когда списки закрыты
				OrderNotifier.out_of_order(session[:phone]).deliver_now
				# OrderNotifier.delay(queue: "no_orders").out_of_order(session[:phone])
			else	
				# Если набор открыт, то следуем дальше логике приложения
				if (@cu.delivery_region == "true" || @cu.delivery_region == "Московская область")
					region = "Московская область, #{@cu.city}"
				else
					region = "Москва"
				end
				@order = Order.new phone: @cu.phone, address: "#{region}, улица #{@cu.street} #{@cu.house_number}/#{@cu.flat_number}"
				menu_param = params[:type] || session[:menu_id]
				persons = params[:people] || session[:people]
				quantity = params[:quantity] || session[:quantity]
				dessert = params[:dessert] || session[:dessert]
				breakfast = params[:breakfast] || session[:breakfast]
				
				@menu = Menu.find(menu_param)
				@menu_price = @menu.calculate_price(@menu, persons, quantity, dessert, breakfast)

				@delivery = @menu.deliveries.to_json(only: [:id, :name], include: { intervals: {only: [:id, :value]}})
				puts "Delivery:"
				puts @delivery.inspect

			
			end
	end

	def create
		@order = Order.new(order_params)

		if params[:delivery_timeframe]
			@order.delivery_timeframe = params[:delivery_timeframe]
			logger.debug "Creating order with delivery timeframe - #{params[:delivery_timeframe]}"
		end


		if params[:menu_type]
			@order.menu_type = params[:menu_type]
		end

		logger.debug "Calling create method with following address type: #{params[:delivery_address]}"
		
		# Here happens some Bitrix magic (see methods below)

		if current_user.orders.count == 0
			logger.debug "Benchmarking 'update_fresh_user_with_order_params'"
			Benchmark.bm do |x|
				x.report do
					update_fresh_user_with_order_params(params, current_user)
				end
			end
		end
		
		logger.debug "Benchmarking 'action_upon_order_creation' - creating lead or deal inside Bitrix"
		Benchmark.bm do |x|
			x.report do
				@bitrix_order_id = action_upon_order_creation(@order)
			end
		end

		@order.bitrix_order_id = @bitrix_order_id
		@order[:user_id] = current_user.id


		if @order.save

			# Только после сохранения добавляем промокод, иначе у нас нет айди заказа
			# Сначала проверяем, валидный ли промокод
			promocode_object = Promocode.is_valid?(@order[:pcode])

			if promocode_object
				logger.debug "Applying promocode discount using #{promocode_object.inspect}"
				# Меняем стоимость набора с учетом скидки, если такая есть
				@order.apply_promocode(promocode_object)
			end
			# закончили добавлять промокод
			
			respond_to do |format|
				format.html { redirect_to edit_order_path(@order) }
			end

		else
			logger.debug "Working with order: #{@order.inspect}"
			flash[:error] = "Пожалуйста, заполните все поля заказа."
			redirect_to new_order_path(type: @order.menu_id, quantity: @order.menu_amount, people: @order.person_amount)
		end

		# Удаляем сессии, что бы они не перезаписали что-нибудь
		session.delete(:menu_id)
		session.delete(:people)
		session.delete(:quantity)
		session.delete(:dessert)
		session.delete(:breakfast)
	end

	def show
	end

	def edit
		# Расчитываем цену для печати чека. Пока такой костыль до внедрения корзины

		menu_amount = @order[:menu_amount]
		person_amount = @order[:person_amount]
		menu_type = @order[:menu_type]
		category_id = Category.find_by(name: menu_type)
		menu = Menu.current.find_by(category_id: category_id)
		menu_personamount = menu.personamounts.find_by(value: person_amount)
		menu_dinner_amount_options = menu_personamount.dinner_amount_options.find_by(day_number: menu_amount)

		menu_price = menu.price + menu_dinner_amount_options.pricechange

		@current_menu = {
			name: "#{menu_type} #{menu_amount}x#{person_amount}",
			price: menu_price
		}

		if @order[:add_dessert]
			dessert_price = Menu.current_dessert[0].price

			@dessert = {
				name: "Десерт",
				price: dessert_price
			}
		else
			@dessert = nil
		end

		if @order[:add_breakfast]

			breakfast_data = Menu.breakfast_data(menu_amount, person_amount, true)

			@breakfast = {
				name: breakfast_data[0],
				price: breakfast_data[1]
			}
		else
			@breakfast = nil
		end
	end

	def out_of_order
	end

	def update

		if @order.update(order_params)
			# Обновляем данные лида
			@order.update_bitrix_lead
			
			respond_to do |format|
				format.html { redirect_to order_path(@order) }
			end

			begin
				OrderNotifier.received(@order).deliver_now
				# OrderNotifier.delay(queue: "orders", priority: 0).received(@order)
				logger.info "Client notification for #{@order.phone} sent."
			rescue => e
				logger.fatal "Client notification for #{@order.phone} failed. Error(s): #{e.message}"
			end

			begin
				OrderNotifier.notifyShop(@order).deliver_now
				# OrderNotifier.delay(queue: "orders", priority: 20).notifyShop(@order)
				logger.info "Shop notification for #{@order.phone} sent."
			rescue => e
				logger.fatal "Shop notification for #{@order.phone} failed. Error(s): #{e.message}"
			end
		else
			render "new"
		end
	end

	def confirm
	end

	private

	def update_fresh_user_with_order_params(order_params, user)
		email = params[:order][:email] || ""
		phone = params[:order][:phone]
		city = params[:order][:city] || ""
		logger.info "Inside updating fresh user with user params: #{phone}"
		
		first_name = params[:order][:first_name] || ""
		second_name = params[:order][:second_name] || ""
		phone = params[:order][:phone] || ""
		# email = params[:order][:email]
		street = params[:order][:street] || ""
		delivery_region = params[:order][:delivery_region]
		if delivery_region == "false"
			city = "Москва"
		end
		house_number = params[:order][:house_number]
		flat_number = params[:order][:flat_number]
		additional_address = params[:order][:additional_address]
	
		user.update(phone: phone, first_name: first_name, second_name: second_name, email: email, street: street, delivery_region: delivery_region, city: city, house_number: house_number, flat_number: flat_number, additional_address: additional_address)
		logger.info "After creating order a fresh user #{first_name} with phone: #{phone} was updated!"
		# message = URI.escape("Вы успешно зарегестрированы! Ваш пароль на сайте http://uzhin-doma.ru - #{password}")
			
	end

	def find_promocode(code)
		Promocode.not_used_yet.where(value: code)[0]
	end

	def apply_promocode(code)
		# Проверяем по базе, есть ли такой промокод и не был ли он уже использован
		promocode_valid = !Promocode.not_used_yet.where(value: code)[0].blank?
		logger.debug "Requested promocode: #{code} is #{promocode_valid}"
		return promocode_valid
	end

	def action_upon_order_creation(order)

		logger.debug "Calling Bitrix.check_token"
		result = Bitrix.check_token
		# logger.debug "Result of check_token is: #{result}"

		phone = params[:order][:phone]
		logger.debug "Chechking if user exists. Benchmarking aswell."
		Benchmark.bm do |x|
			x.report { @user = Bitrix.check_if_user_exists(phone) }
		end
		
		logger.debug "User returned with params: #{@user}"
		# Here we either create a new deal for existing user or create new lead
		# with given data

		if @user
			# create_new_bitrix_deal(user, order)
			id = create_new_bitrix_lead_or_deal("deal", order, @user)
			logger.debug "User with id #{@user} found, creating a new deal inside Bitrix."
		else
			# create_new_bitrix_lead(phone, name, menu_type, address, comment, delivery, order)
			id = create_new_bitrix_lead_or_deal("lead", order)
			logger.debug "No user with phone number: #{phone} found. Creating a new lead inside Bitrix."
		end

		return id

	end

	def check_token
		if @refresh_token.nil?
			init(false)
		elsif (Time.now - @bitrix.updated_at) > 3600	
			init(true)
		else
			# nothing
		end
	end

	def order_params
		params.require(:order).permit(:first_name, :second_name, :street, :phone, :email,
			:delivery_region, :city, :additional_address, :pcode, :address,
			:korpus, :flat_number, :house_number, :comment, :pay_type, :payed_online,
			:person_amount, :menu_amount, :user_id, :change, :menu_id,
			:order_type, :menu_type, :order_price, :delivery_timeframe, :promocode_id,
			:bitrix_order_id, :cloudpayment, :delivery_day, :delivery_time,
			:add_dessert, :add_breakfast)
	end

	def find_order
		@order = Order.find(params[:id])
	end

	def init(refresh)
		Bitrix.get_refresh_token
	end

	def create_new_bitrix_lead_or_deal(type, order, user_id=nil)
		# Получаем токены
		bitrix = Bitrix.first
		title = Date.today.strftime("%d.%m.%y")

		# Интервал доставки для всех типов присутствует
		# Проверяем на "обычную доставку", т.е. если для набора НЕ указан день с интервалами
		# и также проверяем на доставку, где указаны день и интервал
		if order[:delivery_timeframe]
			timeframe = URI.escape(order[:delivery_timeframe])
		elsif order[:delivery_day] && order[:delivery_time]
			timeframe = "#{URI.escape(order[:delivery_day])} #{URI.escape(order[:delivery_time])}"
		end
		# Комментарий также для всех присутствует
		commentary = URI.escape(order[:comment])

		# Получаем код roistat из кук. Это число, но тип - стринг
		roistat_visit = cookies[:roistat_visit]

		# Ставим тип продаж = сайт
		type_id = URI.escape("Сайт")
		
		# Проверяем сначала, нам данные из профиля пользователя брать или из формы
		# Т.е. пользователь должен быть старым и совершить хотя бы один заказ
		if current_user.orders.count > 0

			# Логика под пользователя, у которого уже есть профиль
			
			email = current_user.email || ""
			name = URI.escape("#{current_user.first_name} #{current_user.second_name}")
			phone = current_user.phone

			# Проверяем, ввел ли он новый адрес или использовал старый
			if params[:delivery_address] == "new"
				# Тут логика для опции "Добавить новый адрес"
				# Делаем проверку на Москву, иначе в адресе будет Москва, Москва. Это не есть гут
				if (order[:delivery_region] == "true" || order[:delivery_region] == "Московская область")
					city = "Московская область, #{order[:city]}"
				else
					city = "Москва"
				end

				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, #{order[:street]}, дом #{order[:house_number]}")
				
				# В поле "дополнительная часть" прописываем:
				# номер дома, квартиру, подъезд, этаж
				add_address_fields = ""
				unless order[:flat_number].blank?
					add_address = URI.escape("кв. #{order[:flat_number]}")
					
					unless order[:additional_address].blank?
						rest_address = URI.escape(order[:additional_address]) 
						add_address = "#{add_address}, #{rest_address}"
					end
				end

				# Сохраняем новый адрес у пользователя
				current_user.addresses.create(delivery_region: order[:delivery_region], city: order[:city], street: order[:street], house_number: order[:house_number], flat_number: order[:flat_number], additional_address: order[:additional_address])
			elsif params[:delivery_address] == "current"
				# Тут логика для ПЕРВОГО адреса, который является основным и хранится в полях пользователя, а не
				# в доп. адресах (т.е. это user.street, а не user.addresses.first.street)

				# Делаем проверку на Москву, иначе в адресе будет Москва, Москва. Это не есть гут
				logger.debug("DDDDDDD======= CURRENT MIDDLE ADDRESS ==========DDDDDD")
				
				city = Order.check_delivery_region(current_user)
				

				

				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, #{current_user.street}, дом #{current_user.house_number}")

				# Получаем допник для адреса
				# В поле "дополнительная часть" прописываем:
				# номер дома, квартиру, подъезд, этаж
				add_address_fields = ""
				
				unless current_user.flat_number.blank?
					add_address = URI.escape("кв. #{current_user.flat_number}")
					
					unless current_user.additional_address.blank?
						rest_address = URI.escape(current_user.additional_address)
						add_address = "#{add_address}, #{rest_address}"
					end
					# оригинал, сохраняем для бэкапа
					# add_address_fields = "&fields[UF_CRM_56B8878D6482A]=#{add_address}"
					# add_address_fields = "&fields[UF_CRM_56B8878D39A41]=#{add_address}"
				end
			else
				# Тут логика для адресов, которые "между" первым и последним
				# Т.е. тут все адреса, которые находятся в user.addresses

				# В данном случае мы подставляем поля выбранного дополнительного адреса
				found_address = Address.find(params[:delivery_address].to_i)
				logger.debug("DDDDDDD======= MIDDLE ADDRESS ==========DDDDDD")
				logger.debug("Address: #{found_address}")
				city = Order.check_delivery_region(found_address)
				logger.debug("City: #{found_address}")
				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, #{found_address.street}, дом #{found_address.house_number}")

				# Получаем допник для адреса
				# В поле "дополнительная часть" прописываем:
				# номер дома, квартиру, подъезд, этаж
				add_address_fields = ""
				
				unless found_address.flat_number.blank?
					add_address = URI.escape("кв. #{found_address.flat_number}")
					
					unless found_address.additional_address.blank?
						rest_address = URI.escape(found_address.additional_address)
						add_address = "#{add_address}, #{rest_address}"
					end
					# оригинал, сохраняем для бэкапа
					# add_address_fields = "&fields[UF_CRM_56B8878D6482A]=#{add_address}"
					# add_address_fields = "&fields[UF_CRM_56B8878D39A41]=#{add_address}"
				end
			end
		else
			# Здесь логика под совсем нового пользователя, т.е. которого нет ни в битриксе
			# ни на сайте

			logger.debug("+++++++=============++++++++")
			logger.debug("Creating order for absolutely new user with params: #{order.inspect}")

			# Если payed_online ==  true, то ставим сумму оплаты в соответствующее поле лида
			email = order[:email] || ""
			payment_fields = ""
			payment_string = ""
			name = URI.escape("#{params[:order][:first_name]} #{params[:order][:second_name]}")
			phone = params[:order][:phone]

			# Делаем проверку на Москву, иначе в адресе будет Москва, Москва. Это не есть гут
			if order[:delivery_region] == "false"
				city = "Москва"
			else
				city = "Московская область, #{order[:city]}"
			end

			# Получаем поля адреса из параметров
			address = URI.escape("#{city}, #{order[:street]}, дом #{order[:house_number]}")
			
			# В поле "дополнительная часть" прописываем:
			# номер дома, квартиру, подъезд, этаж
			add_address_fields = ""
			unless order[:flat_number].blank?
				add_address = URI.escape("кв. #{order[:flat_number]}")
				
				unless order[:additional_address].blank?
					rest_address = URI.escape(order[:additional_address]) 
					add_address = "#{add_address}, #{rest_address}"
				end
			end
		end

		# Передаем параметры адреса непосредственно в сделку или в лид

		case type
		when "deal"
			# Тут уникальная ерунда для СДЕЛКИ
			# stage_id = "NEW"
			# opportunity = order[:order_price] if order[:order_price]
			# # Если payed_online ==  true, то ставим сумму оплаты в соответствующее поле сделки
			# if order[:payed_online]
			# 	payment_fields = "&fields[UF_CRM_1467563310]=#{opportunity}&fields[UF_CRM_1459692590]=#{opportunity}"
			# else
			# 	payment_fields = ""
			# end

			# # Интервал доставки
			# timeframe_fields = ""
			# if !timeframe.blank?
			# 	timeframe_fields = "&fields[UF_CRM_1455025743]=#{timeframe}"
			# end

			# # Прописываем все доп. параметры урла в соответствии с данными заказа
			# # для СДЕЛКИ
			# address_fields = "&fields[UF_CRM_56B8878D149C3]=#{address}"
			# add_address_fields = "&fields[UF_CRM_56B8878D6482A]=#{add_address}"

			# logger.info "Creating a new DEAL with params: user_id - #{user_id}, comment - #{commentary}, title - #{title}"
			# fields_string = "fields[TYPE_ID]=#{type_id}&fields[TITLE]=#{title}&fields[STAGE_ID]=#{stage_id}&fields[CONTACT_ID]=#{user_id}&fields[UF_CRM_1468262077]=#{commentary}&fields[UF_CRM_1467999345]=#{user_id}&fields[OPPORTUNITY]=#{opportunity}#{payment_fields}#{address_fields}#{add_address_fields}#{timeframe_fields}"
			
			# url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.add.json?&auth=#{bitrix.access_token}&#{fields_string}"

			# Предыдущее пока комментирую, мбе понадобится. Суть в том, что с 11/03/2017
			# нужно и сделку передавать в лид с разницой в одно только поле "Существующий клиент"

			url = Bitrix.get_fields_string(type, address, add_address, timeframe, name, phone, title, type_id, commentary, email, payment_fields, user_id, roistat_visit)

			logger.info "Benchmarking Bitrix.write_to_crm"
			Benchmark.bm do |x|
				x.report { 
					@id = Bitrix.write_to_crm(url, order, type) 
				}
			end
			# ------------

		when "lead"

			url = Bitrix.get_fields_string(type, address, add_address, timeframe, name, phone, title, type_id, commentary, email, payment_fields, user_id, roistat_visit)

			# long url example
			# auth=bo00krlcimz2k3fggnzzxfusg2rhk3d3&&fields[TITLE]=%D0%98%D0%9F%20%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[NAME]=%D0%93%D0%BB%D0%B5%D0%B1&fields[SECOND_NAME]=%D0%95%D0%B3%D0%BE%D1%80%D0%BE%D0%B2%D0%B8%D1%87&fields[LAST_NAME]=%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[STATUS_ID]=NEW&fields[OPENED]=Y&fields[ASSIGNED_BY_ID]=1&fields[CURRENCY_ID]=USD&fields[OPPORTUNITY]=12500&&fields[PHONE][0][VALUE]=555888&fields[PHONE][0][VALUE_TYPE]=WORK&params[REGISTER_SONET_EVENT]=Y

			logger.info "Benchmarking Bitrix.write_to_crm"
			Benchmark.bm do |x|
				x.report { 
					@id = Bitrix.write_to_crm(url, order, type) 
				}
			end
			# ------------
		end

		return @id
	end


	def get_tokens
		@bitrix = Bitrix.find(1)
		@access_token = @bitrix.access_token
		@refresh_token = @bitrix.refresh_token
	end

	def verify_owner
		@order = Order.find(params[:id])
		unless @order.user_id == current_user.id
			redirect_to root_path
		end
	end

end
