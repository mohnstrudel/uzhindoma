class Category < ActiveRecord::Base
	has_many :orders
	has_many :menus

	scope :dessert, ->{where(name: 'Десерт')}

	scope :without_dessert, lambda{ where.not(name: "Десерт") }

  validates :sortable, :name, presence: true
end
