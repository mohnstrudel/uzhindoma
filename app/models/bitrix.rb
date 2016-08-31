class Bitrix < ActiveRecord::Base

	client_id = "local.57a61102d0b562.81576057"
	client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
	refresh_token = ""
	url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}"

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
