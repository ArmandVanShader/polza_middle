class Order < ApplicationRecord
	has_and_belongs_to_many :dishs, autosave: true, dependent: :destroy
	has_many :ingredients, through: :dishs
	has_and_belongs_to_many :allergens, class_name: "Ingredient", join_table: "allergens_orders", autosave: true, dependent: :destroy

	# генерируем заказы со случайным количеством блюд и случайным наборов аллергенов (от 0 до 5 шт)
	def self.generate(count = 15)
		orders = []
		count.times do |i|
			orders << Order.create!(allergens: Ingredient.random_records(rand(0..5)), dishs: Dish.random_records(rand(1..[1,Dish.count].max)))
		end
		orders
	end

	def to_s
		"№#{id}, #{dishs.count} блюд, #{allergens.count} аллергенов"
	end

	# подсчитывает сводку заказов в блюдах для кухни, за вычетом ингридиентов-аллергенов
	def self.summary
		result = Hash.new(0)
		# получить все заказы, включая их алергены и заказанные блюда, включая их ингридиенты
		orders = Order.strict_loading.all.preload({dishs: :ingredients}).includes(:allergens)
		# итого будет 7 запросов независимо от размера выборки: все заказы, связи с блюдами, сами блюда, связи блюд с игридиентами, ингридиенты блюд, связи заказов с аллергенами, сами аллергены

		# puts "Заказы c алергенами загружены, #{orders.count}"
		dishs = orders.collect{|o| o.dishs}.flatten.uniq
		# puts "Блюда с ингридиентами загружены, #{dishs.count}"
		orders.each do |o|
			# puts "💟 Проверяется заказ №#{o.id}"
			o.dishs.each do |d|
				bad_ingredients = o.allergen_ids & d.ingredient_ids
				unless bad_ingredients.present?
					# puts "🟢 Блюдо #{d.name} безопасно"
					result[d.name] += 1
				else
					# puts "⛔ Блюдо #{d.name} исключено из-за аллергенов #{bad_ingredients}"
				end
			end
		end
		result.sort_by(&:last).reverse.to_h.map{|key,value| {name: key, count: value}}
	end

end
