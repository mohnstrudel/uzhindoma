# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p "Setting database up, please hold on"

categories = Category.create([{ name: 'Суперздоровый', purchasable: true, display_vital: true},
{name: 'Много холестерина', purchasable: true, display_vital: false}])

recipes = Recipe.create([{name: 'Свинина на углях', description: 'Жирная свининка на углях. Ушки подаются отдельно', fat: 1200},
	{name: 'Рулька кабана', description: 'Мощнейшая рулька молодого кабанчика.', fat: 5000, calories: 15000},
	{name: 'Тушеные овощи', description: 'Нет ни жира, ни вкуса, вообще ничего'}, 
	{name: 'Вода дестилированная', description: 'Водичка', fat: 1, calories: 1, carbohydrates: 200}])

p '35% done'

Recipe.find(1).pictures.create(image: File.open(Rails.root + "app/assets/images/seed_images/dish1.jpg"))
Recipe.find(2).pictures.create(image: File.open(Rails.root + "app/assets/images/seed_images/dish2.jpg"))
Recipe.find(3).pictures.create(image: File.open(Rails.root + "app/assets/images/seed_images/dish3.jpg"))
Recipe.find(4).pictures.create(image: File.open(Rails.root + "app/assets/images/seed_images/dish1.jpg"))

p '70% done'

first_menu = Menu.create(category_id: 1, price: 3500, daterange: "10/11/2016 - 31/12/2018")
first_menu.menurecipes.create(recipe_id: 3)
first_menu.menurecipes.create(recipe_id: 4)

second_menu = Menu.create(category_id: 2, price: 6250, daterange: "10/11/2016 - 31/12/2018")
second_menu.menurecipes.create(recipe_id: 1)
second_menu.menurecipes.create(recipe_id: 2)

Setting.create(phone: "89032278874", facebook: "fb", instagram: "ig", vkontakte: "vk", order_mail: 'send@me.com')

p '100% done'
p 'Setup complete'