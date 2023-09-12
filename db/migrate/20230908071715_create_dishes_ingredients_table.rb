class CreateDishesIngredientsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :dishes_ingredients, id: false do |t|
        t.belongs_to :dish
        t.belongs_to :ingredient
    end
  end
end
