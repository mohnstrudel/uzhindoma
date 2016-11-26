# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161126173917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bitrixes", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "purchasable"
    t.boolean  "display_vital"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "jobtitle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "image"
    t.index ["jobtitle_id"], name: "index_employees_on_jobtitle_id", using: :btree
  end

  create_table "igrams", force: :cascade do |t|
    t.string   "url"
    t.string   "author"
    t.text     "description"
    t.string   "thumb_image"
    t.string   "src_image"
    t.integer  "comments"
    t.integer  "likes"
    t.string   "shortcode"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "userpic"
  end

  create_table "instagram_helpers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobtitles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
    t.index ["menu_id"], name: "index_line_items_on_menu_id", using: :btree
    t.index ["order_id"], name: "index_line_items_on_order_id", using: :btree
  end

  create_table "menurecipes", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_menurecipes_on_menu_id", using: :btree
    t.index ["recipe_id"], name: "index_menurecipes_on_recipe_id", using: :btree
  end

  create_table "menus", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "price"
    t.string   "daterange"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "hotpic"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "change_from"
    t.string   "change_to"
    t.text     "description"
    t.index ["category_id"], name: "index_menus_on_category_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "phone"
    t.integer  "category_id"
    t.integer  "menu_id"
    t.integer  "menu_amount"
    t.integer  "person_amount"
    t.boolean  "change"
    t.integer  "user_id"
    t.boolean  "add_dessert"
    t.string   "order_type"
    t.string   "menu_type"
    t.float    "order_price"
    t.string   "delivery_timeframe"
    t.string   "street"
    t.string   "house_number"
    t.string   "korpus"
    t.string   "flat_number"
    t.text     "comment"
    t.index ["category_id"], name: "index_orders_on_category_id", using: :btree
    t.index ["menu_id"], name: "index_orders_on_menu_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "partners", force: :cascade do |t|
    t.string   "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "recipe_id"
    t.index ["recipe_id"], name: "index_pictures_on_recipe_id", using: :btree
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "calories"
    t.integer  "fat"
    t.integer  "carbohydrates"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "instagram"
    t.string   "facebook"
    t.string   "vkontakte"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "order_mail"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "avatar"
    t.string   "phone"
    t.text     "address"
    t.string   "bitrix_id"
    t.string   "integer"
    t.string   "otp_secret_key"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "employees", "jobtitles"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "menus"
  add_foreign_key "line_items", "orders"
  add_foreign_key "menurecipes", "menus"
  add_foreign_key "menurecipes", "recipes"
  add_foreign_key "menus", "categories"
  add_foreign_key "orders", "categories"
  add_foreign_key "orders", "menus"
  add_foreign_key "orders", "users"
  add_foreign_key "pictures", "recipes"
end
