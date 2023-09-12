class Dish < ApplicationRecord
	has_and_belongs_to_many :ingredients, autosave: true
	has_and_belongs_to_many :orders

	def to_s
		"#{name} (#{ingredients.map(&:name).join(', ')})"
	end

	def self.import
		# подгружаем YML
		seed_file = File.join(Rails.root, 'db', 'dataset.yml')
		config = YAML::load_file(seed_file)



		# предполгаем, что среди блюд могут быть не только те ингредиенты, что явно указаны в файле, но ещё и новые
		# Собираем ингредиенты со всех блюд ингредиенты в хэш, чтобы не искать их заново в БД для каждого заносимого блюда
		ingredients = {}
		# перебираем ингредиенты блюд и собираем ключи хэша
		config["dishes"].each{|d| d['ingredients'].each{|key| ingredients[key] = nil}}
		# перебираем явно указанные ингредиенты и собираем ключи хэша
		config["ingredients"].each{ |key| ingredients[key] = nil}

		# получаем id всех ингредиентов, выполняя поиск существующих или создавая новые и наполняя хэш моделями
		# по запросам получается максимум 2N штук. Неэкономно, зато точно будут переиспользованы существующие ингредиенты
		ingredients.each{|name,value| ingredients[name] = Ingredient.find_or_create_by(name: name)}

		# импортируем блюда, предварительно поискав в базе есть ли уже такое, используя ранее найденные модели ингредиентов
		dishes = config["dishes"].map do |d|
			dish = Dish.find_or_create_by(name: d['name'])
			dish.ingredients= d['ingredients'].map{|i| ingredients[i]}
			dish.save
			dish
			# для перепроверки существующиъ блюд тратится 2N запросов
			# для иморта новых блюд получается 2N тратится на сами блюда + N+1 запрос на каждый ингредиент каждого блюда
			# Это много, зато все добавления обёрнуты в транзакции и обеспечивается ссылочная целостность
			# А также имеется возможность переиспользования существующих объектов и обновления состава блюда, если он изменился
			# Если отключить внешние ключи в БД, можно наполнять соеденительные таблицы вручную гораздо меньшим числом запросов.
		end	

		# переводим ингредиенты в массив на случай если потребуется венрнуть их
		ingredients = ingredients.values
		# возвращаем блюда
		dishes
	end
end
