class Bitrix < ActiveRecord::Base

	@client_id = "local.57a61102d0b562.81576057"
	@client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
	@redirect_uri = "http://uzhindoma.eve-trader.net"
	@portal_name = "uzhin-doma"
	@scope = "crm"
	refresh_token = ""
	url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{refresh_token}"
	

	def self.get_refresh_token
		
		begin
			refresh_token = find(1).refresh_token
		rescue ActiveRecord::RecordNotFound
			# if nothing found, we create a new Bitrix entry
			new().save
			logger.info "New Bitrix created"
		end

		# first_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/authorize/?response_type=code&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}"
		# second_url_to_hit = "https://#{@portal_name}.bitrix24.ru/oauth/token/?grant_type=authorization_code&client_id=#{@client_id}&client_secret=#{@client_secret}&redirect_uri=#{@redirect_uri}&scope=#{@scope}&code=#{code}"
		
		begin
			refresh_tokens_url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{refresh_token}"
			doc = Nokogiri::HTML(open(refresh_tokens_url))
			data = JSON.parse(doc)

			new_access_token = data["access_token"]
			new_refresh_token = data["refresh_token"]

			update(access_token: new_access_token, refresh_token: new_refresh_token)

			return "Tokens refreshed and updated"
		rescue Exception => e
			logger.info "Logged out error: #{e}"

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
