class Menupersonamount < ApplicationRecord
  belongs_to :menu
  belongs_to :personamount
  belongs_to :bonuspersonamount, :class_name  => "Personamount", foreign_key: :bonuspersonamount_id
end
