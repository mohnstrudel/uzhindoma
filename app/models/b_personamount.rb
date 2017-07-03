class BPersonamount < ApplicationRecord
  has_many :b_menupersonamounts, dependent: :destroy

  has_many :menus, through: :b_menupersonamounts

  has_many  :dinner_amount_options, dependent: :destroy
  accepts_nested_attributes_for :dinner_amount_options, allow_destroy: true
end
