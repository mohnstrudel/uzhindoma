module Front::DinnerHelper

  def get_delivery_date(object)
    if object.category.name == "Дачное меню"
      return "возможна 09.06.2017"
    else
      return object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
    end
  end

  def add_breakfast_text(menu_name)
    if menu_name == "Завтраки"
      return "Завтраки дешевле при оформлении заказа вместе с ужином"
    else
      return "Завтраки дешевле при оформлении заказа вместе с ужином"
    end
  end

end