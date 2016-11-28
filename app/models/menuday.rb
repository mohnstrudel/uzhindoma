class Menuday < ApplicationRecord
  belongs_to :day
  belongs_to :menu
end
