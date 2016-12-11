class Promocode < ApplicationRecord

	belongs_to :order

	validates_uniqueness_of :value

	# Лучше конечно { where("order_id IS NULL") }, но пока не получается так
	# scope :not_used_yet, lambda { Order.where.not(promocode_ids: self.id) }
	scope :not_used_yet, lambda { where("order_id IS NULL") }

	after_initialize :set_order

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
