class Menu < ActiveRecord::Base

  # scope :current, lambda { where(daterange: "09/05/2016 - 13/05/2016") }
  scope :current, lambda { where("start_time <= ? AND end_time >= ?", Time.now, Time.now) }
  scope :dessert, lambda { where("category_id =?", Category.dessert[0].id)}
  scope :current_dessert, lambda { where("start_time <= ? AND end_time >= ? AND category_id = ?", Time.now, Time.now, Category.dessert[0].id)}
  # scope :ordered, -> { order('category.sortable') }

  after_save :get_date

  mount_uploader :hotpic, PictureUploader


  belongs_to :category

  has_many :menurecipes, dependent: :destroy
  has_many :recipes, through: :menurecipes

  has_many :menupersonamounts, dependent: :destroy
  has_many :personamounts, through: :menupersonamounts

  has_many :menudays, dependent: :destroy
  has_many :days, through: :menudays

  accepts_nested_attributes_for :menurecipes

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  has_many :orders

  def date
    daterange.split(" - ")
  end

  def calculate_price(menu, params)
    price = menu.price

    menu_amount = params[:menu_amount_0] || params[:menu_amount_1] || params[:menu_amount_2]
    # Мы получаем вот такой массив в виде стринга
    # "[150, 20000]", соответсвенно нужно сплитунть на запятой и убрать пробел + скобку
    # (цена всегда на втором месте стоит)
    menu_price_change = menu_amount.split(",")[1].gsub(" ","").gsub("]",'')

    price += menu_price_change.to_f

    person_amount = params[:person_amount_0] || params[:person_amount_1] || params[:person_amount_2]
    person_price_change = person_amount.split(",")[1].gsub(" ","").gsub("]",'')

    price += person_price_change.to_f

    dessert_price = params[:add_dessert_0] || params[:add_dessert_1] || params[:add_dessert_2]

    price += dessert_price.to_f

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
