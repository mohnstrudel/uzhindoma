class Menu < ActiveRecord::Base

  # scope :current, lambda { where(daterange: "09/05/2016 - 13/05/2016") }
  scope :current, lambda { where("start_time <= ? AND end_time >= ?", Time.now, Time.now) }
  scope :no_dessert, lambda { where("category_id != ?", Category.dessert[0].id)}
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

  def calculate_price(menu, persons, quantity, dessert)
    # Получаем базовую цену
    price = menu.price
    pricechange = 0

    dessert_price = Menu.current.dessert[0].price

    # Получаем значение кол-ва человек и ужинов
    person_amount = persons
    menu_amount = quantity


    # Сначала получаем "столбец", т.е. ту запись, которая отвечает за
    # кол-во персон из параметров
    p_amount_id = menu.personamounts.where(value: person_amount)[0].id

    # Тут получаем "строку", т.е. для заданного кол-ва людей получаем
    # кол-во ужинов
    result = Personamount.find(p_amount_id).dinner_amount_options.where(day_number: menu_amount)[0]

    pricechange = result.pricechange

    if dessert == "on"
      price += dessert_price
    end

    price += pricechange.to_i

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
