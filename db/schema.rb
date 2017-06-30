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

ActiveRecord::Schema.define(version: 20170630144635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "card_first_six"
    t.string "card_last_four"
    t.string "card_type"
    t.string "issuer_bank_country"
    t.string "token"
    t.string "card_exp_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "street"
    t.string "house_number"
    t.string "flat_number"
    t.string "delivery_region"
    t.string "city"
    t.string "additional_address"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "main"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.hstore "roles"
    t.string "name"
    t.string "description"
    t.integer "jobtitle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["jobtitle_id"], name: "index_admins_on_jobtitle_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bitrixes", id: :serial, force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blog_categories", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "post_id"
    t.index ["post_id"], name: "index_blog_categories_on_post_id"
  end

  create_table "bootsy_image_galleries", id: :serial, force: :cascade do |t|
    t.string "bootsy_resource_type"
    t.integer "bootsy_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", id: :serial, force: :cascade do |t|
    t.string "image_file"
    t.integer "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "purchasable"
    t.boolean "display_vital"
    t.integer "sortable"
    t.text "description"
  end

  create_table "days", id: :serial, force: :cascade do |t|
    t.integer "value"
    t.string "wordvalue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pricechange"
    t.string "title"
    t.integer "pricechange_four"
    t.integer "sortable"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "name"
    t.string "admin_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dinner_amount_options", id: :serial, force: :cascade do |t|
    t.integer "day_number"
    t.float "pricechange"
    t.integer "personamount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personamount_id"], name: "index_dinner_amount_options_on_personamount_id"
  end

  create_table "employees", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "jobtitle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["jobtitle_id"], name: "index_employees_on_jobtitle_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.float "rating"
    t.string "name"
    t.string "email"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "igrams", id: :serial, force: :cascade do |t|
    t.string "url"
    t.string "author"
    t.text "description"
    t.string "thumb_image"
    t.string "src_image"
    t.integer "comments"
    t.integer "likes"
    t.string "shortcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "userpic"
  end

  create_table "instagram_helpers", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intervals", force: :cascade do |t|
    t.string "value"
    t.bigint "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_id"], name: "index_intervals_on_delivery_id"
  end

  create_table "jobtitles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
  end

  create_table "line_items", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "cart_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["menu_id"], name: "index_line_items_on_menu_id"
    t.index ["order_id"], name: "index_line_items_on_order_id"
  end

  create_table "menudays", id: :serial, force: :cascade do |t|
    t.integer "day_id"
    t.integer "menu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_menudays_on_day_id"
    t.index ["menu_id"], name: "index_menudays_on_menu_id"
  end

  create_table "menudeliveries", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "delivery_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_id"], name: "index_menudeliveries_on_delivery_id"
    t.index ["menu_id"], name: "index_menudeliveries_on_menu_id"
  end

  create_table "menupersonamounts", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "personamount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bonuspersonamount_id"
    t.index ["bonuspersonamount_id"], name: "index_menupersonamounts_on_bonuspersonamount_id"
    t.index ["menu_id"], name: "index_menupersonamounts_on_menu_id"
    t.index ["personamount_id"], name: "index_menupersonamounts_on_personamount_id"
  end

  create_table "menurecipes", id: :serial, force: :cascade do |t|
    t.integer "menu_id"
    t.integer "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sortable"
    t.index ["menu_id"], name: "index_menurecipes_on_menu_id"
    t.index ["recipe_id"], name: "index_menurecipes_on_recipe_id"
  end

  create_table "menus", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "price"
    t.string "daterange"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hotpic"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "change_from"
    t.string "change_to"
    t.text "description"
    t.boolean "has_dessert"
    t.boolean "has_breakfast"
    t.index ["category_id"], name: "index_menus_on_category_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "email"
    t.string "pay_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.integer "category_id"
    t.integer "menu_id"
    t.integer "menu_amount"
    t.integer "person_amount"
    t.boolean "change"
    t.integer "user_id"
    t.boolean "add_dessert"
    t.string "order_type"
    t.string "menu_type"
    t.float "order_price"
    t.string "delivery_timeframe"
    t.string "street"
    t.string "house_number"
    t.string "korpus"
    t.string "flat_number"
    t.text "comment"
    t.boolean "payed_online"
    t.string "delivery_region"
    t.string "first_name"
    t.string "second_name"
    t.string "city"
    t.string "additional_address"
    t.string "pcode"
    t.integer "promocode_id"
    t.integer "bitrix_order_id"
    t.boolean "cloudpayment"
    t.string "delivery_day"
    t.string "delivery_time"
    t.boolean "add_breakfast"
    t.index "lower((first_name)::text) varchar_pattern_ops", name: "orders_lower_first_name"
    t.index "lower((phone)::text) varchar_pattern_ops", name: "orders_lower_phone"
    t.index "lower((second_name)::text) varchar_pattern_ops", name: "orders_lower_second_name"
    t.index ["category_id"], name: "index_orders_on_category_id"
    t.index ["menu_id"], name: "index_orders_on_menu_id"
    t.index ["promocode_id"], name: "index_orders_on_promocode_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "partners", id: :serial, force: :cascade do |t|
    t.string "picture"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "price", null: false
    t.string "alfa_order_id"
    t.string "alfa_form_url"
    t.boolean "paid"
    t.string "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alfa_order_id"], name: "index_payments_on_alfa_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "personamounts", id: :serial, force: :cascade do |t|
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "wordvalue"
    t.integer "pricechange"
    t.string "title"
    t.integer "pricechange_life"
    t.integer "sortable"
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipe_id"
    t.index ["recipe_id"], name: "index_pictures_on_recipe_id"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blog_category_id"
    t.string "logo"
    t.text "seo_description"
    t.string "seo_keywords"
    t.string "preview_pic"
    t.index "lower((title)::text) varchar_pattern_ops", name: "posts_lower_title"
    t.index "lower(body) text_pattern_ops", name: "posts_lower_body"
    t.index ["blog_category_id"], name: "index_posts_on_blog_category_id"
  end

  create_table "promocodes", id: :serial, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id"
    t.integer "discount"
    t.index ["order_id"], name: "index_promocodes_on_order_id"
  end

  create_table "recipes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "calories"
    t.integer "fat"
    t.integer "carbohydrates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "instagram"
    t.string "facebook"
    t.string "vkontakte"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_mail"
    t.string "out_of_order_begin"
    t.string "out_of_order_end"
    t.string "seo_title"
    t.text "seo_description"
    t.string "seo_keywords"
    t.string "blog_header_pic"
    t.string "blog_main_text"
    t.text "address"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email"
    t.string "post_referer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar"
    t.string "phone"
    t.text "address"
    t.string "bitrix_id"
    t.string "integer"
    t.string "otp_secret_key"
    t.string "first_name"
    t.string "second_name"
    t.string "delivery_region"
    t.string "street"
    t.string "house_number"
    t.string "korpus"
    t.string "flat_number"
    t.string "city"
    t.string "additional_address"
    t.boolean "orders_updated", default: false
    t.index "lower((email)::text) varchar_pattern_ops", name: "users_lower_email"
    t.index "lower((first_name)::text) varchar_pattern_ops", name: "users_lower_first_name"
    t.index "lower((phone)::text) varchar_pattern_ops", name: "users_lower_phone"
    t.index "lower((second_name)::text) varchar_pattern_ops", name: "users_lower_second_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "addresses", "users"
  add_foreign_key "blog_categories", "posts"
  add_foreign_key "dinner_amount_options", "personamounts"
  add_foreign_key "employees", "jobtitles"
  add_foreign_key "intervals", "deliveries"
  add_foreign_key "line_items", "carts"
  add_foreign_key "line_items", "menus"
  add_foreign_key "line_items", "orders"
  add_foreign_key "menudays", "days"
  add_foreign_key "menudays", "menus"
  add_foreign_key "menudeliveries", "deliveries"
  add_foreign_key "menudeliveries", "menus"
  add_foreign_key "menupersonamounts", "menus"
  add_foreign_key "menupersonamounts", "personamounts"
  add_foreign_key "menurecipes", "menus"
  add_foreign_key "menurecipes", "recipes"
  add_foreign_key "menus", "categories"
  add_foreign_key "orders", "categories"
  add_foreign_key "orders", "menus"
  add_foreign_key "orders", "promocodes"
  add_foreign_key "orders", "users"
  add_foreign_key "pictures", "recipes"
  add_foreign_key "posts", "blog_categories"
  add_foreign_key "promocodes", "orders"
end
