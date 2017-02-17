class Bitrix < ActiveRecord::Base

	require 'open-uri'
	# require 'curb'

	
	refresh_token = ""
	url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{refresh_token}"
	@client_id = "local.57a61102d0b562.81576057"
	@client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
	@redirect_uri = "http://uzhindoma.eve-trader.net"
	@portal_name = "uzhin-doma"
	@scope = "crm"

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
		parsed_phone = Bitrix.parse_phone(phone)

		access_token = find(1).access_token

		parsed_phone.each do |current_phone|
			fields_string = "filter[PHONE]=#{current_phone}&select[0]=ID&select[1]=NAME&select[2]=LAST_NAME"
			url = "https://uzhin-doma.bitrix24.ru/rest/crm.contact.list.json?&auth=#{access_token}&#{fields_string}"

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

	def self.get_users_orders(user_id)

		get_refresh_token

		access_token = first.access_token
		# This method returns all orders with date and price made by a specific user
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.deal.list.json?&auth=#{access_token}&filter[CONTACT_ID]=#{user_id}"
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

		phone = phone_input.scan(/\d+/).join("")

		output_phone[0] = phone
		# первый анпак генерирует "7900-123-88-22" 
		output_phone[1] = phone.unpack('A4A3A2A2').join('-')
		output_phone[2] = phone.unpack('A1A3A3A2A2').join('-')
		output_phone[3] = phone.unpack('A1A3A3A2A2').join(' ')
		output_phone[4] = phone.unpack('A1A3A7').join('-')
		output_phone[5] = phone.unpack('A1A3A7').join(' ')
		output_phone[6] = phone.unpack('A1A10').join(' ')
		output_phone[7] = phone.unpack('A1A10').join('-')
		output_phone[8] = phone.unpack('A1A10').join('-').unpack('A5A10').join(' ')
		output_phone[9] = phone.unpack('A1A10').join('-').unpack('A5A3A2A2').join(' ')
		output_phone[10] = phone.unpack('A1A10').join(' ').unpack('A5A3A2A2').join('-')
		# Тут нам нужен 7 (925) 700-6838
		output_phone[11] = phone.unpack('A1A10').join(' (').unpack('A6A7').join(') ').unpack('A11A4').join('-')

		# now we need exactly the same with '8' at the beginning

		output_phone.each_with_index do |o_phone, index|
			eight_phone << o_phone.sub('7', '8')
		end

		phone_chain = output_phone.concat(eight_phone)

		phone_chain.each do |element|
			element.gsub! ' ', '%20'
		end

		return phone_chain
	end
end
