class Promocode < ApplicationRecord

	belongs_to :order

	validates_uniqueness_of :value

	# Лучше конечно { where("order_id IS NULL") }, но пока не получается так
	# scope :not_used_yet, lambda { Order.where.not(promocode_ids: self.id) }
	scope :not_used_yet, lambda { where("order_id IS NULL") }

	# На 25/04/2017 Пока не знаю зачем я этот метод сделал
	# after_initialize :set_order

	def update_order(order_id)
		# self.order_id = order_id
		if update_attribute(:order_id, order_id)
			logger.debug "Promocode #{self.value} updated with proper order id - #{order_id}"
		end
	end

	def self.is_valid?(promocode)
		# Метод возвращает целиком объект
		# #<Promocode id: 11, value: "856QZS20I", created_at: "2016-12-11 22:42:34", updated_at: "2016-12-11 22:42:34", order_id: nil> 
		result = not_used_yet.where(value: promocode)
		
		if result.blank?
			return false
		elsif result[0].nil?
			return false
		else
			return result[0]
		end
	end

	def self.generate_code
		first_digits = ('0'..'9').to_a.shuffle[0,3].join
		letters = ('A'..'Z').to_a.shuffle[0,3].join
		second_digits = ('0'..'9').to_a.shuffle[0,2].join
		last_letter = ('A'..'Z').to_a.shuffle[0,1].join

		return "#{first_digits}#{letters}#{second_digits}#{last_letter}"
	end

	def set_order
		self.order_id ||= Order.where(promocode_id: self.id)[0]
	end
end
