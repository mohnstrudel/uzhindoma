class DinnerAmountOption < ApplicationRecord
  belongs_to :personamount, optional: true
  belongs_to :b_personamount, optional: true
end
