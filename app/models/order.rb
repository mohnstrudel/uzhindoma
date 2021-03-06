class Order < ActiveRecord::Base
	belongs_to :category
	belongs_to :user
	belongs_to :menu

	has_one		:promocode

	validates :first_name, :email, :phone, presence: true

	scope :current_weak, lambda { where('created_at > ?', Date.today.at_beginning_of_week)}
	scope :last_weak, lambda { where('created_at > ? AND created_at < ?', (Date.today - 1.week).at_beginning_of_week, Date.today.at_beginning_of_week - 1.day)}

	# validates :delivery_timeframe, presence: true

	def update_bitrix_lead
		Bitrix.update_lead(self.bitrix_order_id, self.cloudpayment, self.order_price, self.pcode)
	end


	def apply_promocode(promocode_object)
		logger.debug "Inside order object - #{self.inspect}"
		logger.debug "Applying СКиДКА to order"
		
		discounted_price = self.order_price + (promocode_object.discount)*(-1)
		
		logger.debug "Setting promocode id to #{promocode_object.id}"
		update_attributes(order_price: discounted_price, promocode_id: promocode_object.id)

		logger.debug "Updating promocode order id for order #{self.id} (or plain id? #{id})"
		promocode_object.update_order(self.id)

	end

	def self.check_delivery_region(object)
		if (object.delivery_region == "true" || object.delivery_region == "Московская область")
			logger.debug("Object.delivery_region is: #{object.delivery_region}")
			logger.debug("Object is: #{object.inspect}")
			logger.debug("Is object true?: #{object.delivery_region == 'true'}")
			
			combined_city = "Московская область, #{object.city}"
		else
			combined_city = "Москва"
		end
		# переменная город содержит в себе либо просто "Москва", либо
		# "Московская область, Железнодорожный"
		logger.debug("Combined city is: #{combined_city}")
		return combined_city
	end

	def self.get_addresses(user)
		puts "Debugging order.rb"
		result = Array.new
		user.addresses.each do |adr|
			if adr.delivery_region == "false"
				city = "Москва"
			else
				city = "Московская область, город #{adr.city}"
			end
			result << ["#{city}, улица #{adr.street}, #{adr.house_number}/#{adr.flat_number}", adr.id]
		end
		# p result
		return result
	end

	def self.check_order_day(current_date)
		setting = Setting.first
		if Rails.env.production? || Rails.env.development?
			# Парсим дату начала и конца
			# e = s.out_of_order_end
 			# => "27-02-2017 11:24" 
			# DateTime.parse(b)
 			# => Mon, 27 Feb 2017 11:24:00 +0000 
			begin_date_to_check = DateTime.parse(setting.out_of_order_begin).change(offset: "+0300")
			end_date_to_check = DateTime.parse(setting.out_of_order_end).change(offset: "+0300")
			# change(offset: "+0300") для того, что бы было +03:00 наравне с Московским временем

			# Проверяем, лежит ли присланная дата между началом и концом
			result = current_date.between?(begin_date_to_check, end_date_to_check)
		else
			# Нам не нужно проверять страницу каждый раз в девелопменте
			# т.е. всегда возвращаем фолс
			result = false
		end
		# Результат содержит тру или фолс в зависимости от того, находится ли
		# текущий день между четвергом и воскресеньем (включительно)
		# Т.е. если мы в пятницу вызываем этот метод, он возвращает тру
		return result
	end
end
