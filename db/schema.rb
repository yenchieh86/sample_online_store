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

ActiveRecord::Schema.define(version: 20170512090324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "title",       default: "", null: false
    t.text     "description", default: "", null: false
    t.integer  "items_count", default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "slug"
    t.index ["slug"], name: "index_categories_on_slug", unique: true, using: :btree
    t.index ["title"], name: "index_categories_on_title", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "items", force: :cascade do |t|
    t.string   "title",                                     default: "",    null: false
    t.text     "description",                               default: "",    null: false
    t.decimal  "price",             precision: 5, scale: 2, default: "0.0"
    t.integer  "stock",                                     default: 0
    t.decimal  "weight",            precision: 5, scale: 2, default: "0.0"
    t.decimal  "length",            precision: 5, scale: 2, default: "0.0"
    t.decimal  "width",             precision: 5, scale: 2, default: "0.0"
    t.decimal  "height",            precision: 5, scale: 2, default: "0.0"
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "sold",                                      default: 0
    t.integer  "status",                                    default: 0,     null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "slug"
    t.json     "pictures"
    t.integer  "order_items_count"
    t.index ["category_id"], name: "index_items_on_category_id", using: :btree
    t.index ["slug"], name: "index_items_on_slug", unique: true, using: :btree
    t.index ["status"], name: "index_items_on_status", using: :btree
    t.index ["title"], name: "index_items_on_title", unique: true, using: :btree
    t.index ["user_id"], name: "index_items_on_user_id", using: :btree
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity",                                  default: 0
    t.decimal  "total_weight",     precision: 7,  scale: 2, default: "0.0"
    t.integer  "status",                                    default: 0
    t.decimal  "total_amount",     precision: 7,  scale: 2, default: "0.0"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.decimal  "total_dimensions", precision: 10, scale: 2, default: "0.0"
    t.index ["item_id"], name: "index_order_items_on_item_id", using: :btree
    t.index ["order_id"], name: "index_order_items_on_order_id", using: :btree
    t.index ["status"], name: "index_order_items_on_status", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "status",                                      default: 0
    t.integer  "order_items_count",                           default: 0
    t.decimal  "shipping",           precision: 7,  scale: 2, default: "0.0"
    t.decimal  "total_weight",       precision: 7,  scale: 2, default: "0.0"
    t.decimal  "tax",                precision: 7,  scale: 2, default: "0.0"
    t.decimal  "order_items_total",  precision: 7,  scale: 2, default: "0.0"
    t.decimal  "order_total_amount", precision: 7,  scale: 2, default: "0.0"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.decimal  "total_dimensions",   precision: 10, scale: 2, default: "0.0"
    t.index ["status"], name: "index_orders_on_status", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "store_activities", force: :cascade do |t|
    t.integer  "total_users",                                  default: 0
    t.integer  "total_categories",                             default: 0
    t.integer  "total_items",                                  default: 0
    t.integer  "total_orders",                                 default: 0
    t.integer  "total_finished_order",                         default: 0
    t.decimal  "total_sales",          precision: 7, scale: 2, default: "0.0"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username",                            null: false
    t.string   "slug"
    t.integer  "role",                   default: 0,  null: false
    t.integer  "items_count",            default: 0
    t.integer  "orders_count"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "items", "categories"
  add_foreign_key "items", "users"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
end
