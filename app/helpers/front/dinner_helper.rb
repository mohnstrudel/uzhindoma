module Front::DinnerHelper

  def get_delivery_date(object)
    object.daterange.split("-")[1].gsub("/",".").gsub(" ", "")
  end

end