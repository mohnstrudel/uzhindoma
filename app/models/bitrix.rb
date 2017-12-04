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

	def self.get_fields_string(type, address, add_address, timeframe, name, phone, title, type_id, commentary, email, payment_fields, user_id, roistat_visit)
		
		bitrix = first

		case type
		when "deal"
			deal_specific_fields = "&fields[UF_CRM_1488879411]=#{user_id}"
		when "lead"
			lead_specific_fields = "&fields[UF_CRM_1488879411]=0"
		end

    # Передаем код roistat
    roistat_fields = ""
    if roistat_visit.present?
      roistat_fields = "&fields[UF_CRM_1498505509]=#{roistat_visit}"
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

    phone_fields = "&fields[PHONE][0][VALUE]=#{phone}&fields[PHONE][0][VALUE_TYPE]=WORK&fields[UF_CRM_1456818304]=#{phone}"

		logger.info "Creating a new lead with params: name - #{name}, phone - #{phone}, title - #{title}"
		fields_string = "fields[SOURCE_ID]=#{type_id}&fields[TITLE]=#{title}&fields[NAME]=#{name}&fields[SECOND_NAME]=#{phone}&fields[UF_CRM_1482065300]=#{commentary}#{phone_fields}&fields[EMAIL][0][VALUE]=#{email}&fields[ADDRESS]=#{address}#{payment_fields}#{address_fields}#{add_address_fields}#{timeframe_fields}#{deal_specific_fields}#{lead_specific_fields}#{complete_order_fields}#{roistat_fields}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{bitrix.access_token}&#{fields_string}"
		
		logger.debug "Calling url: #{URI.decode(url)}"

		return url
	end

	def initialize
    # Для мануального ввода
    # Первый урл - https://uzhin-doma.bitrix24.ru/oauth/authorize/?response_type=code&client_id=local.57a61102d0b562.81576057&redirect_uri=http://uzhindoma.eve-trader.net
    # Второй урл - https://uzhin-doma.bitrix24.ru/oauth/token/?grant_type=authorization_code&client_id=local.57a61102d0b562.81576057&client_secret=0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq&redirect_uri=http://uzhindoma.eve-trader.net&scope=crm&code=#{code}
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
    logger.debug "Writing to crm with params: #{URI.decode(url)}, order: #{order.inspect}, type: #{type}"
    doc = Nokogiri::HTML(open(url))

    response = JSON.parse(doc)
    deal_or_lead_id = response["result"]

    
    # Если промокод указан верно, то discount будет true
    # logger.debug "Creating deal with promocode: #{order[:promocode]}"
    # discount = Bitrix.apply_promocode(order[:promocode])
    # На данный момент отключаем, так как ребята добавляют скидку через бизнес-процесс, а не через сайт

    # Ищем все наборы на основе данных заказа
    # Например: Стандарт 4х5 и Промо Завтрак 4х5
    # found_products представляет собой хэщ с двумя значенимяи
    # айди каждого набора в Битриксе и его цену
    # Например {main_menu => {12, 5600}, breakfast => {14, 3200}, dessert => {22, 1200}}
    found_products = Bitrix.find_products_for_order(order)

    # Добавляем все товары из Битрикса в битриксовую сделку или лид (на данный момент только в лид)
    Bitrix.add_products_to_order(type, deal_or_lead_id, found_products)
    
    return deal_or_lead_id
  end

  def self.find_products_for_order(order, discount=nil)
    # В данном методе мы определяем, какой товар добавлять в лид/сделку
    menu_amount = order[:menu_amount]
    person_amount = order[:person_amount]
    menu_type = order[:menu_type]

    bitrix = first

    logger.debug "\n"
    logger.debug "Working with: menu_type - #{menu_type}, person_amount - #{person_amount}, menu_amount - #{menu_amount}, dessert - #{order[:add_dessert]}, breakfast - #{order[:add_breakfast]}"
    logger.debug "\n"

    
    found_products = Hash.new
    names_to_search = Array.new
    # Что бы названия в хэше found_products были более понятными, для
    # каждого набора сохраняем какое-то более человеческое название
    hash_names = Array.new
    
    # По-любому добавляем обычный набор
    # Например: Стандарт 4х5
    names_to_search << URI.encode("#{menu_type} #{menu_amount}х#{person_amount}")
    hash_names << "main_menu"

    # Если в заказе стоит галка "добавить завтрак", то ищем промо наборы
    # Промо-Завтраки 3х2
    # Промо-Завтраки 3х4
    # Промо-Завтраки 5х2
    # Промо-Завтраки 5х4
    if order[:add_breakfast]
      names_to_search << URI.encode("Промо-Завтраки #{menu_amount}х#{person_amount}")
      hash_names << "breakfast"
    end

    if order[:add_dessert]
      names_to_search << URI.encode("Десерт")
      hash_names << "dessert"
    end

    if discount
      names_to_search << URI.encode("Скидка")
      hash_names << "discount"
    end

    names_to_search.each_with_index do |name_to_search, index|
      url = "https://uzhin-doma.bitrix24.ru/rest/crm.product.list.json?&auth=#{bitrix.access_token}&filter[NAME]=#{name_to_search}"
      doc = Nokogiri::HTML(open(url))
      response = JSON.parse(doc)
      begin
        found_products[hash_names[index]] = Hash["product_id", response["result"][0]["ID"], "product_price", response["result"][0]["PRICE"]]
      rescue Exception => e
        logger.fatal "No product with name - #{URI.decode(name_to_search)} inside Bitrix found!"
        # flash[:danger] = "К сожалению, данная опция набора не доступна для заказа, пожалуйста, свяжитесь с нашими менеджерами для уточнения."
        # redirect_to dinner_index_path
      end
    end

    return found_products
  end

  def self.apply_promocode(code)
    # Проверяем по базе, есть ли такой промокод и не был ли он уже использован
    promocode_valid = !Promocode.not_used_yet.where(value: code)[0].blank?
    logger.debug "Requested promocode: #{code} is #{promocode_valid}"
    return promocode_valid
  end


  def self.add_products_to_order(order_type, deal_or_lead_id, found_products)
    # С новых пор это всегда лид
    order_type = "lead"
    # Лид

    bitrix = first

    puts "...."
    puts found_products.inspect
    puts "...."

    init_fields = "&id=#{deal_or_lead_id}&"

    product_fields = ""
    # found_products выглядит примерно так - 
    # Например {main_menu => {12, 5600}, breakfast => {14, 3200}, dessert => {22, 1200}}
    # Т.е. в value первым значением идет айди, вторым - цена
    found_products.each_with_index do | (key,value),index |
      product_fields << "&rows[#{index}][PRODUCT_ID]=#{value['product_id']}&rows[#{index}][PRICE]=#{value['product_price']}&rows[0][QUANTITY]=1"
    end


    url = "https://uzhin-doma.bitrix24.ru/rest/crm.#{order_type}.productrows.set.json?&auth=#{bitrix.access_token}#{init_fields}#{product_fields}"
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
