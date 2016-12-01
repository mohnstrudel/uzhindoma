class Day < ApplicationRecord
	has_many :menudays, dependent: :destroy
  	has_many :menus, through: :menudays
end
