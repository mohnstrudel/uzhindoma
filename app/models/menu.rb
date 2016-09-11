class Menu < ActiveRecord::Base

  # scope :current, lambda { where(daterange: "09/05/2016 - 13/05/2016") }
  scope :current, lambda { where("start_time <= ? AND end_time >= ?", Time.now, Time.now) }
  scope :dessert, lambda { where("category_id =?", Category.dessert[0].id)}

  after_save :get_date

  mount_uploader :hotpic, PictureUploader


  belongs_to :category

  has_many :menurecipes, dependent: :destroy
  has_many :recipes, through: :menurecipes

  accepts_nested_attributes_for :menurecipes

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  has_many :orders

  def date
    daterange.split(" - ")
  end

  def calculate_price(menu, params)
    price = menu.price
    case params[:menu_amount]
    when "5"
      subtract = 0
    when "4"
      subtract = 500
    when "3"
      subtract = 1000
    end
    price -= subtract

    case params[:person_amount]
    when "4"
      price *= 2
    end

    price += params[:add_dessert].to_f

    return price

  end

  private

  def get_date
    update_columns start_time: Time.new(yy_mm_dd(0)[2], yy_mm_dd(0)[1], yy_mm_dd(0)[0], 3, 0, 1), 
    end_time: Time.new(yy_mm_dd(1)[2], yy_mm_dd(1)[1], yy_mm_dd(1)[0], 2, 59, 59)
    # self.start_time = Time.new(date[0])
    # self.end_time = Time.new(date[1])
  end

  def yy_mm_dd(index)
    date[index].split("/")
  end

  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, "Line Items present")
      return false
    end
  end


end
