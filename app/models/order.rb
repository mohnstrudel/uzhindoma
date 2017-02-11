class Order < ActiveRecord::Base
	belongs_to :category
	belongs_to :user
	belongs_to :menu

	has_one		:promocode

	# validates :delivery_timeframe, presence: true

	def self.check_delivery_region(object)
		if object.delivery_region == "Москва"
			city = object.delivery_region
		else
			city = "#{object.delivery_region}, #{object.city}"
		end
		# переменная город содержит в себе либо просто "Москва", либо
		# "Московская область, Железнодорожный"
		return city
	end

	def self.get_addresses(user)
		puts "Debugging order.rb"
		result = Array.new
		user.addresses.each do |adr|
			if adr.delivery_region == "Москва"
				city = "Москва"
			else
				city = "#{adr.delivery_region}, город #{adr.city}"
			end
			result << ["#{city}, улица #{adr.street}, #{adr.house_number}/#{adr.flat_number}", adr.id]
		end
		# p result
		return result
	end

	def self.check_order_day(current_date)
		if Rails.env.production?
			days_to_check = [4,5,6,0]
		else
			# Нам не нужно проверять страницу каждый раз в девелопменте
			days_to_check = []
		end
		result = days_to_check.include?(current_date.wday)
		# Результат содержит тру или фолс в зависимости от того, находится ли
		# текущий день между четвергом и воскресеньем (включительно)
		# Т.е. если мы в пятницу вызываем этот метод, он возвращает тру
		return result
	end
end
