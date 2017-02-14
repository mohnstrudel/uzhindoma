class Front::OrdersController < FrontController

	before_action :find_order, only: [:show, :edit, :update]
	before_filter :get_tokens


	def new
		# Перенаправляем пользователя на форму логина, если он уже есть в системе, но не авторизован
		if !User.where(phone: params[:phone]).blank? && !user_signed_in?
			# Пробрасываем в новую сессию значения заказа, потому что нам надо будет вернуться потом на страницу нового
			# заказа с этими же значениями
			# Так как у нас параметры с разными названиями приходят, нужно их обработать (как на странице orders#new)
			# Обычно меню только два, но проверяем на всякий случай три меню (с запасом)
			person_amount = params[:person_amount_0] || params[:person_amount_1] || params[:person_amount_2]
			menu_amount = params[:menu_amount_0] || params[:menu_amount_1] || params[:menu_amount_2]
			add_dessert = params[:add_dessert_0] || params[:add_dessert_1] || params[:add_dessert_2]
			redirect_to new_user_session_path(phone: params[:phone], menu_id: params[:menu_id], person_amount: person_amount, menu_amount: menu_amount, add_dessert: add_dessert)
			flash[:info] = "У вас уже есть аккаунт в нашей системе, пожалуйста, авторизуйтесь перед оформлением заказа."
			# перенаправление end
		else
			logger.debug "Нажато на создание нового заказа"
			@cu = current_user

			# Тут проверяем, какой день сегодня - с четверга по воскресенье отключаем
			# Возможность заказать набор
			if Order.check_order_day(Date.today)
				if user_signed_in?
					session[:phone] = @cu.phone
				else
					session[:phone] = params[:phone]
				end
				logger.debug "Out of order called with phone: #{session[:phone]}"
				redirect_to out_of_order_path
				# Оповещаем админа сайта, что есть заказ в день, когда списки закрыты
				OrderNotifier.out_of_order(session[:phone]).deliver_now
			else	
				if user_signed_in?
					@order = Order.new phone: @cu.phone, address: "#{@cu.delivery_region}, город #{@cu.city}, улица #{@cu.street} #{@cu.house_number}/#{@cu.flat_number}"
				else
					@order = Order.new
				end
				@menu = Menu.find(params[:menu_id])
				@menu_price = @menu.calculate_price(@menu, params)
			end
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

		user_id = create_user_if_not_exists_yet(params)
		
		action_upon_order_creation(@order)

		# Меняем стоимость набора с учетом скидки, если такая есть		
		
		if apply_promocode(@order[:pcode])
			logger.debug "Applying promocode discount for #{@order[:pcode]}"
			@order[:order_price] += find_product("Скидка")[1].to_i

			p_code = find_promocode(@order[:pcode])
			logger.debug "Found p_code: #{p_code.id}"
			@order[:promocode_id] = p_code.id
			p_code_model = Promocode.find(p_code.id)
			logger.debug "Found p_code model: #{p_code_model.id}, trying to update with #{@order[:id]}"
			if p_code_model.update(order_id: @order[:id])
				logger.debug "Promocode updated with proper order id"
			end
		end

		@order[:user_id] = user_id

		if @order.save
			if apply_promocode(@order[:pcode])
				logger.debug "Applying promocode discount for #{@order[:pcode]}"
				@order[:order_price] += find_product("Скидка")[1].to_i

				p_code = find_promocode(@order[:pcode])
				logger.debug "Found p_code: #{p_code.id}"
				@order[:promocode_id] = p_code.id
				p_code_model = Promocode.find(p_code.id)
				logger.debug "Found p_code model: #{p_code_model.id}, trying to update with #{@order.id}"
				if p_code_model.update(order_id: @order.id)
					logger.debug "Promocode updated with proper order id"
				end
			end
			respond_to do |format|
				format.html { redirect_to edit_order_path(@order) }
			end
		else
			render "new"
		end
	end

	def show
	end

	def edit
	end

	def out_of_order
	end

	def update

		if @order.update(order_params)
			respond_to do |format|
				format.html { redirect_to order_path(@order) }
			end

			unless params[:order_type] == "fast"
				OrderNotifier.received(@order).deliver_now
			end
			OrderNotifier.notifyShop(@order).deliver_now
		else
			render "new"
		end
	end

	def confirm
	end

	private

	def create_user_if_not_exists_yet(params)
		email = params[:order][:email] || ""
		phone = params[:order][:phone]
		logger.info "Inside creating new user with user params: #{email}"
		if (User.where(phone: phone)[0].nil?)
			# Вытаскиваем параметры только если пользователя ещё нет в системе
			# что бы зря не нагружать контроллер
			
			first_name = params[:order][:first_name] || ""
			second_name = params[:order][:second_name] || ""
			phone = params[:order][:phone] || ""
			# email = params[:order][:email]
			street = params[:order][:street] || ""
			delivery_region = params[:order][:delivery_region]
			house_number = params[:order][:house_number]
			flat_number = params[:order][:flat_number]
			additional_address = params[:order][:additional_address]
			password = User.generate_password_code
		
			user = User.create(phone: phone, password: password, first_name: first_name, second_name: second_name, email: email, street: street, delivery_region: delivery_region, house_number: house_number, flat_number: flat_number, additional_address: additional_address)
			logger.info "After creating order a complete new user #{first_name} with phone: #{phone} was created."
			message = URI.escape("Вы успешно зарегестрированы! Ваш пароль на сайте http://uzhin-doma.ru - #{password}")
			
			helpers.send_sms(phone, message)

			return user.id
		else
			user = User.where(phone: phone)[0]
			user_id = user.id
			return user_id
		end
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

		check_token

		phone = params[:order][:phone]
		user = check_if_user_exists(phone)
		# Here we either create a new deal for existing user or create new lead
		# with given data

		if user
			# create_new_bitrix_deal(user, order)
			create_new_bitrix_lead_or_deal("deal", order, user)
			logger.debug "User with id #{user} found, creating a new deal inside Bitrix."
		else
			# create_new_bitrix_lead(phone, name, menu_type, address, comment, delivery, order)
			create_new_bitrix_lead_or_deal("lead", order)
			logger.debug "No user with phone number: #{phone} found. Creating a new lead inside Bitrix."
		end

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
			:person_amount, :menu_amount, :add_dessert, :user_id, :change, :menu_id,
			:order_type, :menu_type, :order_price, :delivery_timeframe, :promocode_id)
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
		timeframe = URI.escape(order[:delivery_timeframe]) if order[:delivery_timeframe]
		# Комментарий также для всех присутствует
		commentary = URI.escape(order[:comment])

		# Ставим тип продаж = сайт
		type_id = URI.escape("Сайт")
		
		# Проверяем сначала, нам данные из профиля пользователя брать или из формы
		if @cu = current_user

			# Логика под пользователя, у которого уже есть профиль
			
			email = @cu.email || ""
			name = URI.escape("#{@cu.first_name} #{@cu.second_name}")
			phone = @cu.phone

			# Проверяем, ввел ли он новый адрес или использовал старый
			if params[:delivery_address] == "new"
				# Тут логика для опции "Добавить новый адрес"
				# Делаем проверку на Москву, иначе в адресе будет Москва, Москва. Это не есть гут
				if order[:delivery_region] == "Москва"
					city = order[:delivery_region]
				else
					city = "#{order[:delivery_region]}, #{order[:city]}"
				end

				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, улица #{order[:street]}, дом #{order[:house_number]}")
				
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
				city = Order.check_delivery_region(@cu)

				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, улица #{@cu.street}, дом #{@cu.house_number}")

				# Получаем допник для адреса
				# В поле "дополнительная часть" прописываем:
				# номер дома, квартиру, подъезд, этаж
				add_address_fields = ""
				
				unless @cu.flat_number.blank?
					add_address = URI.escape("кв. #{@cu.flat_number}")
					
					unless @cu.additional_address.blank?
						rest_address = URI.escape(@cu.additional_address)
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

				city = Order.check_delivery_region(found_address)

				# Получаем поля адреса из параметров
				address = URI.escape("#{city}, улица #{found_address.street}, дом #{found_address.house_number}")

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

			# Если payed_online ==  true, то ставим сумму оплаты в соответствующее поле лида
			email = order[:email] || ""
			payment_fields = ""
			payment_string = ""
			name = URI.escape("#{params[:order][:first_name]} #{params[:order][:second_name]}")
			phone = params[:order][:phone]

			# Делаем проверку на Москву, иначе в адресе будет Москва, Москва. Это не есть гут
			if order[:delivery_region] == "Москва"
				city = order[:delivery_region]
			else
				city = "#{order[:delivery_region]}, #{order[:city]}"
			end

			# Получаем поля адреса из параметров
			address = URI.escape("#{city}, улица #{order[:street]}, дом #{order[:house_number]}")
			
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
			stage_id = "NEW"
			opportunity = order[:order_price] if order[:order_price]
			# Если payed_online ==  true, то ставим сумму оплаты в соответствующее поле сделки
			if order[:payed_online]
				payment_fields = "&fields[UF_CRM_1467563310]=#{opportunity}&fields[UF_CRM_1459692590]=#{opportunity}"
			else
				payment_fields = ""
			end

			# Интервал доставки
			timeframe_fields = ""
			if !timeframe.blank?
				timeframe_fields = "&fields[UF_CRM_1455025743]=#{timeframe}"
			end

			# Прописываем все доп. параметры урла в соответствии с данными заказа
			# для СДЕЛКИ
			address_fields = "&fields[UF_CRM_56B8878D149C3]=#{address}"
			add_address_fields = "&fields[UF_CRM_56B8878D39A41]=#{add_address}"

			logger.info "Creating a new DEAL with params: user_id - #{user_id}, comment - #{commentary}, title - #{title}"
			fields_string = "fields[TYPE_ID]=#{type_id}&fields[TITLE]=#{title}&fields[STAGE_ID]=#{stage_id}&fields[CONTACT_ID]=#{user_id}&fields[UF_CRM_1468262077]=#{commentary}&fields[UF_CRM_1467999345]=#{user_id}&fields[OPPORTUNITY]=#{opportunity}#{payment_fields}#{address_fields}#{add_address_fields}#{timeframe_fields}"
			
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.add.json?&auth=#{bitrix.access_token}&#{fields_string}"

			doc = Nokogiri::HTML(open(url))

			response = JSON.parse(doc)
			deal_id = response["result"]

			found_product = find_product_for_order(order)


			# Если промокод указан верно, то discount будет true
			logger.debug "Creating deal with promocode: #{order[:promocode]}"
			discount = apply_promocode(order[:promocode])
			
			answer = format_id_and_prices(found_product, order[:add_dessert], discount)
			product_id = answer[0]
			product_price = answer[1]
			dessert_id = answer[2]
			dessert_price = answer[3]
			# Скидка
			discount_id = answer[4]
			discount_price = answer[5]

			# Добавляем все товары из Битрикса в битриксовую сделку
			add_products_to_order(type, deal_id, product_id, product_price, dessert_id, dessert_price, discount_id, discount_price)

		when "lead"

			address_fields = "&fields[UF_CRM_1454918385]=#{address}"
			add_address_fields = "&fields[UF_CRM_1454918441]=#{add_address}"

			# Интервал доставки
			timeframe_fields = ""
			if !timeframe.blank?
				timeframe_fields = "&fields[UF_CRM_1484728934]=#{timeframe}"
			end

			logger.info "Creating a new lead with params: name - #{name}, phone - #{phone}, title - #{title}"
			fields_string = "fields[SOURCE_ID]=#{type_id}&fields[TITLE]=#{title}&fields[NAME]=#{name}&fields[SECOND_NAME]=#{phone}&fields[UF_CRM_1482065300]=#{commentary}&fields[PHONE][0][VALUE]=#{phone}&fields[EMAIL][0][VALUE]=#{email}&fields[PHONE][0][VALUE_TYPE]=WORK&fields[ADDRESS]=#{address}#{payment_fields}#{address_fields}#{add_address_fields}#{timeframe_fields}"
			
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{bitrix.access_token}&#{fields_string}"
			
			logger.debug "Calling url: #{url}"

			# long url example
			# auth=bo00krlcimz2k3fggnzzxfusg2rhk3d3&&fields[TITLE]=%D0%98%D0%9F%20%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[NAME]=%D0%93%D0%BB%D0%B5%D0%B1&fields[SECOND_NAME]=%D0%95%D0%B3%D0%BE%D1%80%D0%BE%D0%B2%D0%B8%D1%87&fields[LAST_NAME]=%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[STATUS_ID]=NEW&fields[OPENED]=Y&fields[ASSIGNED_BY_ID]=1&fields[CURRENCY_ID]=USD&fields[OPPORTUNITY]=12500&&fields[PHONE][0][VALUE]=555888&fields[PHONE][0][VALUE_TYPE]=WORK&params[REGISTER_SONET_EVENT]=Y

			doc = Nokogiri::HTML(open(url))
			response = JSON.parse(doc)

			lead_id = response["result"]

			found_product = find_product_for_order(order)

			# Если промокод указан верно, то discount будет true
			discount = apply_promocode(order[:promocode])
			
			answer = format_id_and_prices(found_product, order[:add_dessert], discount)
			product_id = answer[0]
			product_price = answer[1]
			dessert_id = answer[2]
			dessert_price = answer[3]
			# Скидка
			discount_id = answer[4]
			discount_price = answer[5]


			# Добавляем все товары из Битрикса в битриксовый лид
			add_products_to_order(type, lead_id, product_id, product_price, dessert_id, dessert_price, discount_id, discount_price)
			# @response = JSON.parse(doc)
		end
	end

	def format_id_and_prices(found_product, dessert, discount)
		
		# Добавить десерт, если в заказе выбрано
		dessert_id = nil
		dessert_price = nil

		# Дефолтные nil-значения для скидки
		discount_id = nil
		discount_price = nil

		if dessert
			dessert_name = Menu.current_dessert[0].recipes[0][:name]
			found_dessert = find_product("Десерт")
			dessert_id = found_dessert[0]
			dessert_price = found_dessert[1]
		end

		if discount
			found_discount = find_product("Скидка")
			discount_id = found_discount[0]
			discount_price = found_discount[1]
		end
		product_id = found_product[0]
		product_price = found_product[1]

		return product_id, product_price, dessert_id, dessert_price, discount_id, discount_price
	end

	def find_product(name)
		bitrix = Bitrix.first
		# Меняем с вариабельного имени на "Десерт", потому что ребята всегда добавляют один и тот же битриксовый товар.
		name = URI.escape(name)
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.product.list.json?&auth=#{bitrix.access_token}&filter[NAME]=#{name}"
		doc = Nokogiri::HTML(open(url))
		response = JSON.parse(doc)

		return response["result"][0]["ID"], response["result"][0]["PRICE"]
	end

	def find_product_for_order(order)
		if order[:order_type] == "fast"
			menu_type = order[:menu_type]
			person_amount = 2
			menu_amount = 5
		else
			menu_id = order[:menu_id]
			menu_type = Menu.find(menu_id).category.name

			person_amount = order[:person_amount]
			menu_amount = order[:menu_amount]
		end
		
		bitrix = Bitrix.first

		logger.debug "\n"
		logger.debug order
		logger.debug "Working with: menu_type - #{menu_type}, person_amount - #{person_amount}, menu_amount - #{menu_amount}"
		logger.debug "\n"

		name_to_search = URI.escape("#{menu_type} #{menu_amount}х#{person_amount}")

		url = "https://uzhin-doma.bitrix24.ru/rest/crm.product.list.json?&auth=#{bitrix.access_token}&filter[NAME]=#{name_to_search}"
		doc = Nokogiri::HTML(open(url))
		response = JSON.parse(doc)

		begin
			product_id = response["result"][0]["ID"]
			product_price = response["result"][0]["PRICE"]
		rescue Exception => e
			logger.fatal "No product with name - #{URI.encode(name_to_search)} inside Bitrix found!"
			flash[:danger] = "К сожалению, данная опция набора не доступна для заказа, пожалуйста, свяжитесь с нашими менеджерами для уточнения."
			# redirect_to dinner_index_path
		end

		return product_id, product_price
	end

	def add_products_to_order(order_type, deal_id, product_id, product_price, dessert_id, dessert_price, discount_id, discount_price)
		bitrix = Bitrix.first
		fields_string = "&id=#{deal_id}&&rows[0][PRODUCT_ID]=#{product_id}&rows[0][PRICE]=#{product_price}&rows[0][QUANTITY]=1"
		dessert_string = ""
		discount_string = ""
		if dessert_id
			dessert_string = "&rows[1][PRODUCT_ID]=#{dessert_id}&rows[1][PRICE]=#{dessert_price}&rows[1][QUANTITY]=1"
			if discount_id
				discount_string = "&rows[2][PRODUCT_ID]=#{discount_id}&rows[2][PRICE]=#{discount_price}&rows[2][QUANTITY]=1"
			end
		elsif !dessert_id && discount_id
			discount_string = "&rows[1][PRODUCT_ID]=#{discount_id}&rows[1][PRICE]=#{discount_price}&rows[1][QUANTITY]=1"
		end
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.#{order_type}.productrows.set.json?&auth=#{bitrix.access_token}#{fields_string}#{dessert_string}#{discount_string}"

		doc = Nokogiri::HTML(open(url))
	end

	def check_if_user_exists(phone)
		# In this method we first search for user and, if found, create a deal or a lead

		# Let's translate phone into something, that might be inside Bitrix
		# method is in bitrix.rb model
		# @client_data = Array.new

		bitrix = Bitrix.first
		parsed_phone = Bitrix.parse_phone(phone)

		parsed_phone.each do |current_phone|
			fields_string = "filter[PHONE]=#{current_phone}&select[0]=ID&select[1]=NAME&select[2]=LAST_NAME"
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.contact.list.json?&auth=#{bitrix.access_token}&#{fields_string}"
			
			logger.debug "Using phone: #{current_phone}"
			logger.debug "Searching for user using this URL: "
			logger.debug url


			doc = Nokogiri::HTML(open(url))
			client_data = JSON.parse(doc)
			unless client_data["result"].empty?
				# Here we return the found client's ID
				return client_data["result"][0]["ID"]
			end
		end
		# If no user found we return nil
		return nil
	end

	def get_tokens
		@bitrix = Bitrix.find(1)
		@access_token = @bitrix.access_token
		@refresh_token = @bitrix.refresh_token
	end

end
