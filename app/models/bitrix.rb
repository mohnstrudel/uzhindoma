class Bitrix < ActiveRecord::Base
	client_id = "local.57a61102d0b562.81576057"
	client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"
	refresh_token = ""
	url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}"

	def self.get_token
		return access_token
	end
end
