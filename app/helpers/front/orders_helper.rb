module Front::OrdersHelper

  def get_price_matrix(current_menu)
    # Итог метода должен быть такой
    # 2{2:0,3:600,5:1000}|4{2:0,3:700,5:1200}

    result = Array.new
    # Это возвращает данные вот в такмо формате
    # "3:0.0,4:600.0,5:1000.0" 
    current_menu.personamounts.each do |pm|
      pm_string = pm.dinner_amount_options.map {|item| "#{item.day_number}:#{item.pricechange.to_i}" }.sort{ |x,y| y <=> x }.join(",")
      pm_string = "#{pm.value}{#{pm_string}}"
      result << pm_string
    end

    joined_result = result.join("|")
    puts "..."
    puts "price matrix is:"
    puts joined_result.inspect
    return joined_result
  end
end