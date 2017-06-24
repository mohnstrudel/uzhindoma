class Delivery < ApplicationRecord
  has_many :intervals, dependent: :destroy
  
  accepts_nested_attributes_for :intervals, :allow_destroy => true

  has_many :menudeliveries, dependent: :destroy
  has_many :menus, through: :menudeliveries


end
