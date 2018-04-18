module Front::DinnerHelper

  def get_delivery_date(object)
    if object.category.name == "Дачное меню"
      # return "возможна 09.06.2017"
      return object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
    else
      return object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
    end
  end

  def add_breakfast_text(menu_name)
    if menu_name == "Завтраки"
      return "Берите завтраки и ужины вместе. Получите скидку на весь заказ."
    else
      return "Берите завтраки и ужины вместе. Получите скидку на весь заказ."
    end
  end

end