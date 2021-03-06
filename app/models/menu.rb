class Menu < ActiveRecord::Base

  # scope :current, lambda { where(daterange: "09/05/2016 - 13/05/2016") }
  scope :current, lambda { where("start_time <= ? AND end_time >= ?", Time.zone.now, Time.zone.now) }
  scope :no_dessert, lambda { where("category_id != ?", Category.dessert[0].id)}
  scope :dessert, lambda { where("category_id =?", Category.dessert[0].id)}
  scope :current_dessert, lambda { where("start_time <= ? AND end_time >= ? AND category_id = ?", Time.zone.now, Time.zone.now, Category.dessert[0].id)}
  scope :current_breakfast, lambda { where("start_time <= ? AND end_time >= ? AND category_id = ?", Time.zone.now, Time.zone.now, Category.breakfast[0].id)}
  # scope :ordered, -> { order('category.sortable') }

  validates :daterange, presence: true

  validate :presence_of_dessert
  # validates :sortable, presence:  true, :if => "menurecipes.present?"

  after_save :get_date
  after_update :get_date

  mount_uploader :hotpic, PictureUploader


  belongs_to :category

  has_many :menurecipes, dependent: :destroy
  has_many :recipes, through: :menurecipes
  accepts_nested_attributes_for :menurecipes, allow_destroy: true

  has_many :menupersonamounts, dependent: :destroy
  has_many :personamounts, through: :menupersonamounts

  has_many :b_menupersonamounts, dependent: :destroy
  has_many :b_personamounts, through: :b_menupersonamounts

  has_many :menudeliveries, dependent: :destroy
  has_many :deliveries, through: :menudeliveries

  has_many :menudays, dependent: :destroy
  has_many :days, through: :menudays

  accepts_nested_attributes_for :menurecipes

  has_many :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  has_many :orders

  def presence_of_dessert
    if Menu.current.dessert.empty? && self.has_dessert
      errors.add(:menu, "Нельзя сохранить набор с опцией 'можно добавить десерт', когда десерта нет. Либо уберите опцию, либо создайте десерт.")
    end
  end

  def date
    daterange.split(" - ")
  end

  def self.get_breakfast_days(menu_amount, person_amount)
    if (menu_amount == 4 and person_amount == 4)
      # если выбираю 4 на 4 давать завтрак 5 на 4
      days = 5
    elsif (menu_amount == 4 and person_amount == 2)
      # если 4 на 2 завтрак 3 на 2!
      days = 3
    else
      days = menu_amount
    end

    return days
  end

  def self.breakfast_data(menu_amount, person_amount, is_additional)
    # Преобразовываем инпут в числа
    menu_amount = menu_amount.to_i
    person_amount = person_amount.to_i
 
    days = Menu.get_breakfast_days(menu_amount, person_amount)

    people = person_amount
    breakfast = Menu.current_breakfast[0]
    puts "Settings: breakfast #{days}x#{people}"
    puts "Menu_amount: #{days}, Person_amount: #{people}"
    if is_additional
      p "Breakfast is, when added to menu: #{breakfast.inspect}"
      p breakfast_personamount = breakfast.b_personamounts.find_by(value: people)

    else
      p "Breakfast is, when separate: #{breakfast.inspect}"
      p breakfast_personamount = breakfast.personamounts.find_by(value: people)
    end
    p breakfast_dinner_amount_options = breakfast_personamount.dinner_amount_options.find_by(day_number: days)
      
    breakfast_price = breakfast.price + breakfast_dinner_amount_options.pricechange
    breakfast_name = "Завтрак #{days}x#{people}"

    return breakfast_name, breakfast_price
  end

  def calculate_price(menu, persons, quantity, dessert, breakfast)
    # Получаем базовую цену
    logger.info "----- Calculating menu price -----"
    price = menu.price
    pricechange = 0

    logger.info "Current price is: #{price} rubles."


    begin
      dessert_price = Menu.current.dessert[0].price
    rescue NoMethodError=>e
      dessert_price = 0
      p "Error encountered: #{e.message}"
    end

    # Получаем значение кол-ва человек и ужинов
    person_amount = persons
    menu_amount = quantity

    logger.info "Current person_amount is: #{person_amount}, current menu_amount is: #{menu_amount}."
    # Данные завтрака
    if (breakfast == "on" || breakfast == true)
      # Вызываем is_additional? == true, т.е. даем понять, что завтрак идет как дополнение
      # а не как отдельное меню
      breakfast_data = Menu.breakfast_data(menu_amount, person_amount, true)
    else
      breakfast_data = Menu.breakfast_data(menu_amount, person_amount, false)
    end
    logger.info "Current breakfast data is: #{breakfast_data}"


    # Сначала получаем "столбец", т.е. ту запись, которая отвечает за
    # кол-во персон из параметров
    p_amount_id = menu.personamounts.where(value: person_amount)[0].id

    logger.info "Current p_amount_id is: #{p_amount_id}."

    # Тут получаем "строку", т.е. для заданного кол-ва людей получаем
    # кол-во ужинов
    result = Personamount.find(p_amount_id).dinner_amount_options.where(day_number: menu_amount)[0]

    logger.info "Current result is: #{result}."

    pricechange = result.pricechange

    logger.info "Current pricechange is: #{pricechange}."

    if (dessert == "on" || dessert == true)
      price += dessert_price
    end

    if (breakfast == "on" || breakfast == true)
      price += breakfast_data[1]
    end

    price += pricechange.to_i
    
    logger.info "#{price} rubles."
    return price

  end

  private

  def get_date
    update_columns start_time: DateTime.new(yy_mm_dd(0)[2].to_i, yy_mm_dd(0)[1].to_i, yy_mm_dd(0)[0].to_i).beginning_of_day, 
    end_time: DateTime.new(yy_mm_dd(1)[2].to_i, yy_mm_dd(1)[1].to_i, yy_mm_dd(1)[0].to_i).end_of_day
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
