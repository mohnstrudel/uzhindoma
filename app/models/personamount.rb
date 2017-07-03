class Personamount < ApplicationRecord
	has_many :menupersonamounts, dependent: :destroy

  has_many :menus, through: :menupersonamounts

  has_many  :dinner_amount_options, dependent: :destroy
  accepts_nested_attributes_for :dinner_amount_options, allow_destroy: true
end
