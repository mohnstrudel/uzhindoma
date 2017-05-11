class Bitrix < ActiveRecord::Base

  refresh_token = ""
  url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{refresh_token}"
  @client_id = "local.57a61102d0b562.81576057"
  @client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
  @redirect_uri = "http://uzhindoma.eve-trader.net"
  @portal_name = "uzhin-doma"
  @scope = "crm"

	require 'open-uri'
	# require 'curb'

	def self.get_fields_string(type, address, add_address, timeframe, name, phone, title, type_id, commentary, email, payment_fields, user_id)
		
		bitrix = first

		case type
		when "deal"
			deal_specific_fields = "&fields[UF_CRM_1488879411]=#{user_id}"
		when "lead"
			lead_specific_fields = "&fields[UF_CRM_1488879411]=0"
		end

		address_fields = "&fields[UF_CRM_1454918385]=#{address}"
		add_address_fields = "&fields[UF_CRM_1454918441]=#{add_address}"

		# Интервал доставки
		timeframe_fields = ""
		if !timeframe.blank?
			timeframe_fields = "&fields[COMMENTS]=#{timeframe}"
		end

    # поле "Дожать" - при создании нового заказа всегда ставим 0
    # только если клиент редактирует заказ (==завершает)
    # то ставим 1
    complete_order_fields = "&fields[UF_CRM_1492756981]=0"

    # Тут мы можем получать какой угодно телефон, мы их все
    # приводим в вид 8хххуууаабб этим методом
    phone = Bitrix.parse_phone(phone)

		logger.info "Creating a new lead with params: name - #{name}, phone - #{phone}, title - #{title}"
		fields_string = "fields[SOURCE_ID]=#{type_id}&fields[TITLE]=#{title}&fields[NAME]=#{name}&fields[SECOND_NAME]=#{phone}&fields[UF_CRM_1482065300]=#{commentary}&fields[PHONE][0][VALUE]=#{phone}&fields[EMAIL][0][VALUE]=#{email}&fields[PHONE][0][VALUE_TYPE]=WORK&fields[ADDRESS]=#{address}#{payment_fields}#{address_fields}#{add_address_fields}#{timeframe_fields}#{deal_specific_fields}#{lead_specific_fields}#{complete_order_fields}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{bitrix.access_token}&#{fields_string}"
		
		logger.debug "Calling url: #{url}"

		return url
	end

	def initialize
		# Метод деприкейтед

		# @client_id = "local.57a61102d0b562.81576057"
		# @client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
		# @redirect_uri = "http://uzhindoma.eve-trader.net"
		# @portal_name = "uzhin-doma"
		# @scope = "crm"
		
		# first_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/authorize/?response_type=code&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}"
		# puts first_url_to_hit

		# # Since there are two urls to hit we first go the first one and try to obtain the
		# # 'code' variable
		# res = Net::HTTP.get_response(URI(first_url_to_hit))
		# authorize_url = res['location']

		# # Since we're redirected to authorization page with our initial request, we 
		# # need to authorize via CURL
		# c = Curl::Easy.new(authorize_url)
		# c.http_auth_types = :basic
		# c.username = 'anton@yadadya.com'
		# c.password = 'muerex123'
		# c.http_post(authorize_url) do |curl| 
		#     curl.headers["Content-Type"] = ["application/json"]
		# end

		# # Now let's parse the headers and get the Location value, which will hold
		# # the 'code' variable
		# puts "---- headers begin ----"
		# p c.header_str
		# http_headers = c.header_str.split(/[\r\n]+/).map(&:strip)
		# http_headers = Hash[http_headers.flat_map{ |s| s.scan(/^(\S+): (.+)/) }]
		# puts "---- headers end ----"
		# url_with_code = http_headers['Location']

		# puts "***"
		# puts url_with_code
		# puts "***"
		
		# # Now we need to extract the 'code' variable from the headers location
		# query_params = URI.parse(url_with_code).query
		# params_hash = URI::decode_www_form(query_params).to_h

		# puts code = params_hash['code']

		# second_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/token/?grant_type=authorization_code&client_id=#{@client_id}&client_secret=#{@client_secret}&redirect_uri=#{@redirect_uri}&scope=#{@scope}&code=#{code}"
		# puts second_url_to_hit
		# doc = Nokogiri::HTML(open(second_url_to_hit))
		# result = JSON.parse(doc)

		# puts result

		
		# After hitting the second URL we need to extract access_token and refresh_token

		# First of all we need to check if there is a simple request possible
		# If not, then we need to update our refresh_token or access_token
	end

  def self.update_lead(lead_id, cloudpayment, payment_amount, promocode_value)
    Bitrix.check_token
    # Мы получаем: айдишник лида для апдейта
    # оплатил ли клиент через клаудпейментс (тру/фолс)
    # сколько оплатил (сумма)
    
    bitrix = first
    
    # Поле "Дожать" - если мы обновляем, то это значит, что клиент точно завершил заказ
    complete_order_fields = "&fields[UF_CRM_1492756981]=1"

    # Ставим дефолт
    payment_fields = ""
    promocode_fields = ""
    
    if cloudpayment
      # эта проверка значит, что картой
      payment_fields = "&fields[UF_CRM_1493722363]=#{payment_amount}"
    else
      # наличные
      payment_fields = "&fields[UF_CRM_1493722305]=#{payment_amount}"
    end

    promocode_fields = promocode_value ? "&fields[UF_CRM_1493970171]=#{promocode_value}" : ""
    url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.update.json?&auth=#{bitrix.access_token}&id=#{lead_id}#{complete_order_fields}#{payment_fields}#{promocode_fields}"
    doc = Nokogiri::HTML(open(url))

    # Для логирования
    response = JSON.parse(doc)
    logger.info "Lead updated with response:"
    logger.info response
    logger.info "Url called was:"
    logger.info url
  end

  def self.write_to_crm(url, order, type)

    logger.debug "+_+_+_+___+__+_+_+_+_+"
    logger.debug "Writing to crm with params: #{url}, order: #{order.inspect}, type: #{type}"
    doc = Nokogiri::HTML(open(url))

    response = JSON.parse(doc)
    deal_or_lead_id = response["result"]

    found_product = Bitrix.find_product_for_order(order)

    # Если промокод указан верно, то discount будет true
    logger.debug "Creating deal with promocode: #{order[:promocode]}"
    discount = Bitrix.apply_promocode(order[:promocode])
    
    answer = Bitrix.format_id_and_prices(found_product, order[:add_dessert], discount)
    product_id = answer[0]
    product_price = answer[1]
    dessert_id = answer[2]
    dessert_price = answer[3]
    # Скидка
    discount_id = answer[4]
    discount_price = answer[5]

    # Добавляем все товары из Битрикса в битриксовую сделку
    Bitrix.add_products_to_order(type, deal_or_lead_id, product_id, product_price, dessert_id, dessert_price, discount_id, discount_price)
    
    return deal_or_lead_id
  end

  def self.find_product_for_order(order)
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
    
    bitrix = first

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

  def self.apply_promocode(code)
    # Проверяем по базе, есть ли такой промокод и не был ли он уже использован
    promocode_valid = !Promocode.not_used_yet.where(value: code)[0].blank?
    logger.debug "Requested promocode: #{code} is #{promocode_valid}"
    return promocode_valid
  end

  def self.format_id_and_prices(found_product, dessert, discount)
    logger.debug "INSPECTING FORMAT ID AND PRICES PARAMS"
    logger.debug "found_product - #{found_product}, dessert - #{dessert}, discount - #{discount}"
    # Добавить десерт, если в заказе выбрано
    dessert_id = nil
    dessert_price = nil

    # Дефолтные nil-значения для скидки
    discount_id = nil
    discount_price = nil

    if dessert
      p "0000000000"
      logger.debug "DESSERT FOUND! ADDING!"
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

  def self.find_product(name)
    bitrix = first
    # Меняем с вариабельного имени на "Десерт", потому что ребята всегда добавляют один и тот же битриксовый товар.
    name = URI.escape(name)
    url = "https://uzhin-doma.bitrix24.ru/rest/crm.product.list.json?&auth=#{bitrix.access_token}&filter[NAME]=#{name}"
    doc = Nokogiri::HTML(open(url))
    response = JSON.parse(doc)

    return response["result"][0]["ID"], response["result"][0]["PRICE"]
  end

  def self.add_products_to_order(order_type, deal_or_lead_id, product_id, product_price, dessert_id, dessert_price, discount_id, discount_price)
    # С новых пор это всегда лид
    order_type = "lead"
    # Лид

    bitrix = first
    fields_string = "&id=#{deal_or_lead_id}&&rows[0][PRODUCT_ID]=#{product_id}&rows[0][PRICE]=#{product_price}&rows[0][QUANTITY]=1"
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
    logger.debug("Adding products to order with url: #{url}")
    doc = Nokogiri::HTML(open(url))
  end

  def self.check_token
    bitrix = find(1)
    # logger.debug "Inside check_token now with bitrix"
    # logger.debug "Refresh token is: #{bitrix.refresh_token}"
    # logger.debug "Access token is: #{bitrix.access_token}"
    if (Time.now - bitrix.updated_at) >= 3599
      Bitrix.get_refresh_token
      logger.info "Tokens updated!"
    end
  end

	def self.get_refresh_token
		
		begin
			refresh_token = find(1).refresh_token
		rescue ActiveRecord::RecordNotFound
			# if nothing found, we create a new Bitrix entry
			new().save
			logger.info "New Bitrix created"
		end

		first_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/authorize/?response_type=code&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}"
		# second_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/token/?grant_type=authorization_code&client_id=#{@client_id}&client_secret=#{@client_secret}&redirect_uri=#{@redirect_uri}&scope=#{@scope}&code=#{code}"
		# debug
		begin
			refresh_tokens_url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{refresh_token}"
			puts refresh_tokens_url
			doc = Nokogiri::HTML(open(refresh_tokens_url))
			data = JSON.parse(doc)

			new_access_token = data["access_token"]
			new_refresh_token = data["refresh_token"]

			update(access_token: new_access_token, refresh_token: new_refresh_token)

			return "Tokens refreshed and updated"
		rescue Exception => e
			logger.info "Method 'get_refresh_token' aborted. Logged out error: #{e}"

		end
		# res = Net::HTTP.get_response(URI(first_url_to_hit))
		# code = res['location']
	end

	def self.check_if_user_exists(phone)
    # In this method we first search for user and, if found, create a deal or a lead

    # Let's translate phone into something, that might be inside Bitrix
    # method is in bitrix.rb model
    # @client_data = Array.new

    bitrix = first
    parsed_phone = Bitrix.parse_phone(phone)

    fields_string = "filter[UF_CRM_1489071594]=#{parsed_phone}&select[0]=ID&select[1]=NAME&select[2]=LAST_NAME"
    url = "https://uzhin-doma.bitrix24.ru/rest/crm.contact.list.json?&auth=#{bitrix.access_token}&#{fields_string}"
    
    logger.debug "Using phone: #{phone}"
    logger.debug "Searching for user using this URL: "
    logger.debug url


    doc = Nokogiri::HTML(open(url))
    client_data = JSON.parse(doc)["result"]

    unless client_data.empty?
      # Here we return the found client's ID
      # используем -1, что бы, если результатов больше одного, то мы получали последний
      # Также проверяем, если результатов больше 1, то шлем письмецо
      logger.debug "Client data:"
      p client_data
      logger.debug "Result length: #{client_data.length}"

      if client_data.length > 1
        ApplicationMailer.delay(queue: "users").notify_if_multiple_bitrix_users(phone, client_data)
      end
      return client_data[-1]["ID"]
    end
    # If no user found we return nil
    return nil
	end

	def self.get_users_orders(user_id)

		get_refresh_token

		access_token = first.access_token
		# This method returns all orders with date and price made by a specific user
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.list.json?&auth=#{access_token}&filter[CONTACT_ID]=#{user_id}"
		logger.debug "Calling get_users_orders with url: #{url}"
    doc = Nokogiri::HTML(open(url))
		result = JSON.parse(doc)
	end

	def self.get_productrows_for_order(order_id)

		access_token = first.access_token
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.productrows.get.json?&auth=#{access_token}&ID=#{order_id}"
		doc = Nokogiri::HTML(open(url))
		result = JSON.parse(doc)
		return result["result"]
	end

	def self.get_token
		return access_token
	end

	def self.parse_phone(phone_input)
		output_phone = Array.new
		eight_phone = Array.new

    # на данный момент в битриксе все телефоны с такой маской:
    # 89687121212
		# we receive a randomly inputted phone number, like +7 968-712 12-12
		# we strip out only digits and then transform into 
		# all possible outcomes for Bitrix phone input

		# Let's go through all possible inputs
		# 7 9001238822
		# 7 900 1238822
		# 7 900 123 88 22
		# 79001238822
		# 7-900 123 88 22
		# 7-900-123-88-22
		# 7900-123-88-22
		# 7 900-123-88-22

		# Output is an array of all phone number possibilities
    # Скан делает из "+7 (968) 714-47-17" "79687144717" 
		phone = phone_input.scan(/\d+/).join("")

    # Заменяем первую цифру на восмерку
    phone[0] = "8"
    # Теперь у нас единственный и идеальный вариант для битрикса
    # т.е. "89687144717" 

		return phone
	end
end
