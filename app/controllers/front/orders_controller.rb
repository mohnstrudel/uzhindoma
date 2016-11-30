class Front::OrdersController < FrontController

	before_action :find_order, only: [:show]
	before_action :find_bitrix, only: [:index, :init, :create_new_lead, :create_new_order, :check_token, :action_upon_order_creation]
	before_action :get_tokens, only: [:index, :init, :create_new_lead, :create_new_order, :check_token, :action_upon_order_creation]


	def new
		@cu = current_user
		if user_signed_in?
			@order = Order.new phone: @cu.phone, address: "#{@cu.delivery_region}, город #{@cu.city}, улица #{@cu.street} #{@cu.house_number}/#{@cu.flat_number}"
		else
			@order = Order.new
		end
		@menu = Menu.find(params[:menu_id])
		@menu_price = @menu.calculate_price(@menu, params)
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

		logger.debug "Calling create method with following params: #{params}"
		# Here happens some Bitrix magic (see methods below)

		create_user_if_not_exists_yet(params)
		
		action_upon_order_creation(@order)

		if @order.save
			respond_to do |format|
				format.html { redirect_to @order}
			end

			unless params[:order][:order_type] == "fast"
				OrderNotifier.received(@order).deliver_now
			end
			OrderNotifier.notifyShop(@order).deliver_now
		else
			render "new"
		end
	end

	def show
	end

	private

	def create_user_if_not_exists_yet(params)
		phone = params[:order][:phone]
		logger.info "Inside creating new user with user params: #{params[:order]}"
		if User.where(phone: phone)[0].nil?
			# Вытаскиваем параметры только если пользователя ещё нет в системе
			# что бы зря не нагружать контроллер
			
			first_name = params[:order][:first_name]
			second_name = params[:order][:second_name]
			email = params[:order][:email]
			street = params[:order][:street]
			delivery_region = params[:order][:delivery_region]
			house_number = params[:order][:house_number]
			flat_number = params[:order][:flat_number]
			password = User.generate_password_code
		
			User.create(phone: phone, password: password, first_name: first_name, second_name: second_name, email: email, street: street, delivery_region: delivery_region, house_number: house_number, flat_number: flat_number)
			logger.info "After creating order a complete new user #{first_name} with phone: #{phone} was created."
			message = URI.escape("Вы успешно зарегестрированы! Ваш пароль на сайте http://uzhin-doma.ru - #{password}")
			
			helpers.send_sms(phone, message)
		end
	end

	def action_upon_order_creation(order)

		check_token

		phone = params[:order][:phone]
		name = URI.escape("#{params[:order][:first_name]} #{params[:order][:second_name]}")
		menu_type = params[:menu_type]
		address = URI.escape("Адрес: Улица - #{params[:order][:street]}/#{params[:order][:house_number]}, квартира номер #{params[:order][:flat_number]} (корпус #{params[:order][:korpus]})")
		comment = params[:order][:comment]
		delivery = params[:order][:delivery_timeframe]

		user = check_if_user_exists(phone)
		# Here we either create a new deal for existing user or create new lead
		# with given data

		if user
			create_new_bitrix_deal(user, order)
			logger.debug "User with id #{user} found, creating a new deal inside Bitrix."
		else
			create_new_bitrix_lead(phone, name, menu_type, address, comment, delivery)
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
			:delivery_region, :city,
			:korpus, :flat_number, :house_number, :comment, :pay_type, :payed_online,
			:person_amount, :menu_amount, :add_dessert, :user_id, :change, :menu_id,
			:order_type, :menu_type, :order_price, :delivery_timeframe)
	end

	def find_order
		@order = Order.find(params[:id])
	end

	def init(refresh)
		Bitrix.get_refresh_token
	end

	def create_new_bitrix_lead(phone, name, menu_type, address, comment, delivery)
		# auth=КЛЮЧ&fields[TITLE]=test&fields[NAME]=ИМЯ
		bitrix = Bitrix.first
		title = Date.today.strftime("%d.%m.%y")
		encoded_name = URI.escape(name)
		commentary = URI.escape("Тип набора: #{menu_type}, Комментарий клиента: #{comment}, Интервал доставки: #{delivery}")
		encoded_address = URI.escape(address)

		logger.info "Creating a new lead with params: name - #{encoded_name}, phone - #{phone}, title - #{title} and menu type - #{menu_type}"
		fields_string = "fields[TITLE]=#{title}&fields[NAME]=#{encoded_name}&fields[SECOND_NAME]=#{phone}&fields[COMMENTS]=#{commentary}&fields[PHONE][0][VALUE]=#{phone}&fields[PHONE][0][VALUE_TYPE]=WORK&fields[ADDRESS]=#{address}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{bitrix.access_token}&#{fields_string}"
		
		logger.debug "Calling url: #{url}"

		# long url example
		# auth=bo00krlcimz2k3fggnzzxfusg2rhk3d3&&fields[TITLE]=%D0%98%D0%9F%20%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[NAME]=%D0%93%D0%BB%D0%B5%D0%B1&fields[SECOND_NAME]=%D0%95%D0%B3%D0%BE%D1%80%D0%BE%D0%B2%D0%B8%D1%87&fields[LAST_NAME]=%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[STATUS_ID]=NEW&fields[OPENED]=Y&fields[ASSIGNED_BY_ID]=1&fields[CURRENCY_ID]=USD&fields[OPPORTUNITY]=12500&&fields[PHONE][0][VALUE]=555888&fields[PHONE][0][VALUE_TYPE]=WORK&params[REGISTER_SONET_EVENT]=Y

		doc = Nokogiri::HTML(open(url))
		# @response = JSON.parse(doc)
	end

	def create_new_bitrix_deal(user_id, order)
		# getting order data
		opportunity = order[:order_price] if order[:order_price]
		address = URI.escape(order[:address]) if order[:address]
		timeframe = URI.escape(order[:delivery_timeframe]) if order[:delivery_timeframe]
		bitrix = Bitrix.first

		title = Date.today.strftime("%d.%m.%y")
		stage_id = "NEW"
		fields_string = "fields[TITLE]=#{title}&fields[STAGE_ID]=#{stage_id}&fields[CONTACT_ID]=#{user_id}&fields[UF_CRM_1467999345]=#{user_id}&fields[OPPORTUNITY]=#{opportunity}&fields[UF_CRM_56B8878D5D5CC]=#{address}&fields[UF_CRM_1455025743]=#{timeframe}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.add.json?&auth=#{bitrix.access_token}&#{fields_string}"

		doc = Nokogiri::HTML(open(url))

		response = JSON.parse(doc)
		deal_id = response["result"]

		found_product = find_product_for_order(order)
		
		# Добавить десерт, если в заказе выбрано
		dessert_id = nil
		dessert_price = nil

		if order[:add_dessert]
			dessert_name = Menu.current_dessert[0].recipes[0][:name]
			found_dessert = find_dessert(dessert_name)
			dessert_id = found_dessert[0]
			dessert_price = found_dessert[1]
		end
		product_id = found_product[0]
		product_price = found_product[1]

		# Добавляем все товары из Битрикса в битриксовую сделку
		add_products_to_deal(deal_id, product_id, product_price, dessert_id, dessert_price)

	end

	def find_dessert(name)
		bitrix = Bitrix.first
		name = URI.escape(name)
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.product.list.json?&auth=#{bitrix.access_token}&filter[NAME]=#{name}"
		doc = Nokogiri::HTML(open(url))
		response = JSON.parse(doc)

		return response["result"][0]["ID"], response["result"][0]["PRICE"]
	end

	def find_product_for_order(order)
		menu_id = order[:menu_id]
		menu_type = Menu.find(menu_id).category.name

		person_amount = order[:person_amount]
		menu_amount = order[:menu_amount]
		bitrix = Bitrix.first

		logger.debug "\n"
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

	def add_products_to_deal(deal_id, product_id, product_price, dessert_id, dessert_price)
		bitrix = Bitrix.first
		fields_string = "&id=#{deal_id}&&rows[0][PRODUCT_ID]=#{product_id}&rows[0][PRICE]=#{product_price}&rows[0][QUANTITY]=1"
		dessert_string = ""
		if dessert_id
			dessert_string = "&rows[1][PRODUCT_ID]=#{dessert_id}&rows[1][PRICE]=#{dessert_price}&rows[1][QUANTITY]=1"
		end
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.productrows.set.json?&auth=#{bitrix.access_token}#{fields_string}#{dessert_string}"

		doc = Nokogiri::HTML(open(url))
	end

	def check_if_user_exists(phone)
		# In this method we first search for user and, if found, create a deal or a lead
		bitrix = Bitrix.first

		# Let's translate phone into something, that might be inside Bitrix
		# method is in bitrix.rb model
		# @client_data = Array.new
		parsed_phone = Bitrix.parse_phone(phone)

		parsed_phone.each do |current_phone|
			fields_string = "filter[PHONE]=#{current_phone}&select[0]=ID&select[1]=NAME&select[2]=LAST_NAME"
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.contact.list.json?&auth=#{bitrix.access_token}&#{fields_string}"

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


	def find_bitrix
		@bitrix = Bitrix.find(1)
	end

	def get_tokens
		@access_token = @bitrix.access_token
		@refresh_token = @bitrix.refresh_token
	end

end
