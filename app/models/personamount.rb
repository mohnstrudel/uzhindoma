class Personamount < ApplicationRecord
	has_many :menupersonamounts, dependent: :destroy
  	has_many :menus, through: :menupersonamounts
end
