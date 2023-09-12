class CreateAllergensOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :allergens_orders, id: false do |t|
      t.belongs_to :ingredient
      t.belongs_to :order
    end
  end
end
