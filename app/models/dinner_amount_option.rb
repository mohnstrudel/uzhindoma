class DinnerAmountOption < ApplicationRecord
  belongs_to :personamount, optional: true
  belongs_to :bonus_personamount, optional: true
end
