class Order < ActiveRecord::Base
	belongs_to :category
	belongs_to :user
	belongs_to :menu

	has_one		:promocode

	# validates :delivery_timeframe, presence: true

	def self.check_order_day(current_date)
		days_to_check = [4,5,6,0]
		result = days_to_check.include?(current_date.wday)
		# Результат содержит тру или фолс в зависимости от того, находится ли
		# текущий день между четвергом и воскресеньем (включительно)
		# Т.е. если мы в пятницу вызываем этот метод, он возвращает тру
		return result
	end
end
