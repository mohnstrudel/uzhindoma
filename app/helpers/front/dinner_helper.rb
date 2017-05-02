module Front::DinnerHelper

  def get_delivery_date(object)
    if object.category.name == "Дачное меню"
      return "возможна 04.05.2017 и 05.05.2017"
    else
      return object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
    end
  end

end