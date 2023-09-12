class Ingredient < ApplicationRecord
	has_and_belongs_to_many :dishes
	has_and_belongs_to_many :orders, :as => :allergens, join_table: "allergens_orders"
end
