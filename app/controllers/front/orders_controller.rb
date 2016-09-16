class Front::OrdersController < FrontController

	before_action :find_order, only: [:show]
	before_action :find_bitrix, only: [:index, :init, :create_new_lead, :create_new_order, :check_token, :action_upon_order_creation]
	before_action :get_tokens, only: [:index, :init, :create_new_lead, :create_new_order, :check_token, :action_upon_order_creation]


	def new
		cu = current_user
		if user_signed_in?
			@order = Order.new name: cu.name, phone: cu.phone, email: cu.email, address: cu.address
		else
			@order = Order.new
		end
		@menu = Menu.find(params[:menu_id])
		@menu_price = @menu.calculate_price(@menu, params)
	end

	def create
		@order = Order.new(order_params)

		if params[:menu_type]
			@order.menu_type = params[:menu_type]
		end

		logger.debug "Calling create method with following params: #{params}"
		# Here happens some Bitrix magic (see methods below)
		action_upon_order_creation

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

	def action_upon_order_creation

		check_token

		phone = params[:order][:phone]
		name = params[:order][:name]
		menu_type = params[:menu_type]

		user = check_if_user_exists(phone)
		# Here we either create a new deal for existing user or create new lead
		# with given data

		if user
			create_new_bitrix_deal(user)
			logger.debug "User with id #{user} found, creating a new deal inside Bitrix."
		else
			create_new_bitrix_lead(phone, name, menu_type)
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
		params.require(:order).permit(:name, :address, :city, :phone, :email, 
			:person_amount, :menu_amount, :add_dessert, :user_id, :change, :menu_id,
			:order_type, :menu_type)
	end

	def find_order
		@order = Order.find(params[:id])
	end

	def init(refresh)
		@bitrix = Bitrix.find(1)

		client_id = "local.57a61102d0b562.81576057"
		client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"

		# refresh is either true or false

		if refresh
			logger.debug "Setting variable refresh token to currently saved refresh token."
			refresh_token = @bitrix.refresh_token
		else
			logger.debug "Grabbing the original refresh token."
			refresh_token = "tbplkp08llfu6943ga68v8bowv5ggtdw"
		end
		url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}"
		doc = Nokogiri::HTML(open(url))
		data = JSON.parse(doc)
		new_access_token = data["access_token"]
		new_refresh_token = data["refresh_token"]

		logger.debug "Received new tokens from Bitrix call. Access token is: #{new_access_token}. Refresh token is: #{new_refresh_token}."

		@bitrix.update(access_token: new_access_token, refresh_token: new_refresh_token)
		
		# debug
	end

	def create_new_bitrix_lead(phone, name, menu_type)
		# auth=КЛЮЧ&fields[TITLE]=test&fields[NAME]=ИМЯ
		title = Date.today.strftime("%d.%m.%y")
		encoded_name = URI.escape(name)
		commentary = URI.escape("Тип набора: #{menu_type}")
		logger.info "Creating a new lead with params: name - #{encoded_name}, phone - #{phone}, title - #{title} and menu type - #{menu_type}"
		fields_string = "fields[TITLE]=#{title}&fields[NAME]=#{encoded_name}&fields[SECOND_NAME]=#{phone}&fields[COMMENTS]=#{commentary}&fields[PHONE][0][VALUE]=#{phone}&fields[PHONE][0][VALUE_TYPE]=WORK"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{@bitrix.access_token}&#{fields_string}"
		
		logger.debug "Calling url: #{url}"

		# long url example
		# auth=bo00krlcimz2k3fggnzzxfusg2rhk3d3&&fields[TITLE]=%D0%98%D0%9F%20%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[NAME]=%D0%93%D0%BB%D0%B5%D0%B1&fields[SECOND_NAME]=%D0%95%D0%B3%D0%BE%D1%80%D0%BE%D0%B2%D0%B8%D1%87&fields[LAST_NAME]=%D0%A2%D0%B8%D1%82%D0%BE%D0%B2&fields[STATUS_ID]=NEW&fields[OPENED]=Y&fields[ASSIGNED_BY_ID]=1&fields[CURRENCY_ID]=USD&fields[OPPORTUNITY]=12500&&fields[PHONE][0][VALUE]=555888&fields[PHONE][0][VALUE_TYPE]=WORK&params[REGISTER_SONET_EVENT]=Y

		doc = Nokogiri::HTML(open(url))
		# @response = JSON.parse(doc)
	end

	def create_new_bitrix_deal(user_id)
		title = Date.today.strftime("%d.%m.%y")
		stage_id = "NEW"
		fields_string = "fields[TITLE]=#{title}&fields[STAGE_ID]=#{stage_id}&fields[CONTACT_ID]=#{user_id}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.add.json?&auth=#{@bitrix.access_token}&#{fields_string}"

		doc = Nokogiri::HTML(open(url))

	end

	def check_if_user_exists(phone)
		# In this method we first search for user and, if found, create a deal or a lead

		# Let's translate phone into something, that might be inside Bitrix
		# method is in bitrix.rb model
		# @client_data = Array.new
		parsed_phone = Bitrix.parse_phone(phone)

		parsed_phone.each do |current_phone|
			fields_string = "filter[PHONE]=#{current_phone}&select[0]=ID&select[1]=NAME&select[2]=LAST_NAME"
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.contact.list.json?&auth=#{@bitrix.access_token}&#{fields_string}"

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
