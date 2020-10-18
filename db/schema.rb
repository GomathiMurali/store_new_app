# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_29_054441) do

  create_table "line_items", force: :cascade do |t|
    t.string "variant_id"
    t.decimal "price"
    t.integer "grams"
    t.integer "quantity"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "product_id"
    t.string "variant_id"
    t.string "title"
    t.decimal "price"
    t.integer "quantity"
    t.integer "grams"
    t.string "financial_status"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "country"
    t.string "country_id"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.string "zip"
    t.string "province"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "product_types", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.text "body_html"
    t.string "image"
    t.decimal "price"
    t.decimal "compare_at_price"
    t.decimal "cost"
    t.string "sku"
    t.string "barcode"
    t.boolean "tracked"
    t.boolean "continue_selling"
    t.integer "available"
    t.decimal "weight"
    t.decimal "weight_unit"
    t.string "countries"
    t.integer "inventory_quantity"
    t.integer "inventory_item_id"
    t.string "inventory_management"
    t.string "inventory_policy"
    t.boolean "requires_shipping"
    t.string "fulfillment_service"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "varients", force: :cascade do |t|
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
