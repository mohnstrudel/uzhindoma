class Front::BitrixController < FrontController
	require 'open-uri'
	require 'nokogiri'
	require 'json'

	before_action :find_bitrix, only: [:index, :init, :create_new_lead, :create_new_order]
	before_action :get_tokens, only: [:index, :init, :create_new_lead, :create_new_order]

	def init(refresh)
		client_id = "local.57a61102d0b562.81576057"
		client_secret = "0yuHxQBOufkvZzOMTAtpIXOajQop3HLpECeIy2HQ0rXE3OnFfq"

		if refresh
			refresh_token = @bitrix.refresh_token
		else
			refresh_token = "tbplkp08llfu6943ga68v8bowv5ggtdw"
		end
		url = "https://oauth.bitrix.info/oauth/token/?grant_type=refresh_token&client_id=#{client_id}&client_secret=#{client_secret}&refresh_token=#{refresh_token}"
		doc = Nokogiri::HTML(open(url))
		data = JSON.parse(doc)
		new_access_token = data["access_token"]
		new_refresh_token = data["refresh_token"]

		@bitrix.update(access_token: new_access_token, refresh_token: new_refresh_token)
		
		# debug
	end



	def create_new_lead
		title = "some_test_title"
		name = "some_test_name"
		method = "crm.lead.add(fields, params)"
		# auth=КЛЮЧ&fields[TITLE]=test&fields[NAME]=ИМЯ
		
		fields_string = "fields[TITLE]=#{title}&fields[NAME]=#{name}"
		
		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.add.json?&auth=#{@bitrix.access_token}&#{fields_string}"

		doc = Nokogiri::HTML(open(url))
		@response = JSON.parse(doc)

		p @response
		redirect_to bitrix_path
	end

	def create_new_order
		# In this method we first search for user and, if found, create a deal or a lead
		redirect_to bitrix_path
	end

	def index
		
		# debug
		if @refresh_token.nil?
			init(false)
		elsif (Time.now - @bitrix.updated_at) > 3600	
			init(true)
		else
			# nothing
		end

		# now we always do have up to date refresh tokens

		url = "https://uzhin-doma.bitrix24.ru/rest/crm.lead.list.json?&auth=#{@bitrix.access_token}"
		doc = Nokogiri::HTML(open(url))
		@data = JSON.parse(doc)
	end

	def find_bitrix
		@bitrix = Bitrix.find(1)
	end

	def get_tokens
		@access_token = @bitrix.access_token
		@refresh_token = @bitrix.refresh_token
	end
end
