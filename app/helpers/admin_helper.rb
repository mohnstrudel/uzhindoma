module AdminHelper

	def get_route(controller)
		model = controller.split("/")[1]

		case model
		when "users"
			return "Пользователи"
		when "orders"
			return "Заказы"
		when "recipes"
			return "Рецепты"
		when "menus"
			return "Наборы"
		when "categories"
			return "Категории"
		end

	end

	def parse_percentage(current_period_value, last_period_value)
		# Если заказов на этой неделе 6, а на прошлой было 12, то мы 
		# должны получить на выходе -50% и слово "падение"
		# если получаем позитивное число, то слово будет "рост"
		result = ((current_period_value/last_period_value.to_f)*100) - 100
		if result < 0
			word = "Упадок"
			c_tag_class = "fa fa-arrow-down pr5 text-danger"
		elsif result == 0
			word = "Стагнация"
			c_tag_class = "fa fa-arrow-right pr5"
		else
			word = "Рост"
			c_tag_class = "fa fa-arrow-up pr5 text-success"
		end

		c_tag = content_tag(:i, "", class: c_tag_class)
		percentage = result.abs.round(2)
		# Возвращаем процент (52% например) и слово ("рост" например)
		return "#{c_tag}#{percentage}% #{word}"

	end

	def object_name(object)
    if object.is_a?(ActiveRecord::Relation)
      return object.model.name.underscore
    else
      return object.class.name.underscore
    end
  end


	def link_to_add_fields(name, f, association)
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |builder|
			render(association.to_s.singularize + "_fields", f: builder)
		end
		link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub("\n", "")})
	end
end
