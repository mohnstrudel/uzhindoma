# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160511071425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "menurecipes", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "menurecipes", ["menu_id"], name: "index_menurecipes_on_menu_id", using: :btree
  add_index "menurecipes", ["recipe_id"], name: "index_menurecipes_on_recipe_id", using: :btree

  create_table "menus", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "price"
    t.datetime "daterange"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "menus", ["category_id"], name: "index_menus_on_category_id", using: :btree

  create_table "pictures", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "recipe_id"
  end

  add_index "pictures", ["recipe_id"], name: "index_pictures_on_recipe_id", using: :btree

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "calories"
    t.integer  "fat"
    t.integer  "carbohydrates"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "menurecipes", "menus"
  add_foreign_key "menurecipes", "recipes"
  add_foreign_key "menus", "categories"
  add_foreign_key "pictures", "recipes"
end
