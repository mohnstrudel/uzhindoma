module Front::DinnerHelper

  def get_delivery_date(object)
    if object.category.name == "Дачное меню"
      return "возможна 09.06.2017"
    else
      return object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
    end
  end

end