class Menurecipe < ActiveRecord::Base
  belongs_to :menu
  belongs_to :recipe

  validates :sortable, presence: true, on: :update
end
