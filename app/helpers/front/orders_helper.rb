module Front::OrdersHelper

  def get_price_matrix(current_menu, options={})
    # Итог метода должен быть такой
    # 2{2:0,3:600,5:1000}|4{2:0,3:700,5:1200}
    # Сортировка должна быть обязательно от малого занчения персон к большому

    if options[:bonus]
      # Если бонус тру, то считаем по бонусным (промо) персонам
      sub_object = "b_personamounts"
    else
      sub_object = "personamounts"
    end

    result = Array.new
    # Это возвращает данные вот в таком формате
    # "3:0.0,4:600.0,5:1000.0" 
    begin 
      current_menu.send(sub_object).order(value: :asc).each do |pm|
        pm_string = pm.dinner_amount_options.map {|item| "#{item.day_number}:#{item.pricechange.to_i}" }.sort{ |x,y| y <=> x }.join(",")
        pm_string = "#{pm.value}{#{pm_string}}"
        result << pm_string
      end

      joined_result = result.join("|")
      return joined_result
    rescue StandardError => e
      return "2{2:0,3:0,5:0}|4{2:0,3:0,5:0}"
      logger.debug "Errors inside get_price_matrix occured: #{e.message}"
    end
  end
end