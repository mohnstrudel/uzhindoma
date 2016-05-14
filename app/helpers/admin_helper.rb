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
end
