# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_08_075202) do
  create_table "allergens_orders", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "ingredient_id"
    t.bigint "order_id"
    t.index ["ingredient_id"], name: "index_allergens_orders_on_ingredient_id"
    t.index ["order_id"], name: "index_allergens_orders_on_order_id"
  end

  create_table "dishes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dishes_ingredients", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "ingredient_id"
    t.index ["dish_id"], name: "index_dishes_ingredients_on_dish_id"
    t.index ["ingredient_id"], name: "index_dishes_ingredients_on_ingredient_id"
  end

  create_table "dishes_orders", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "dish_id"
    t.bigint "order_id"
    t.index ["dish_id"], name: "index_dishes_orders_on_dish_id"
    t.index ["order_id"], name: "index_dishes_orders_on_order_id"
  end

  create_table "ingredients", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
