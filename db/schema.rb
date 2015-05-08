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

ActiveRecord::Schema.define(version: 20150508104353) do

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_no"
    t.string   "phone_no_confirmation_token"
    t.datetime "phone_no_confirmed_at"
    t.integer  "phone_no_confirmation_frequency", default: 0, null: false
    t.string   "postal"
    t.string   "county"
    t.string   "district"
    t.string   "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.integer  "quantity"
    t.integer  "user_id"
    t.integer  "product_boxing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carts", ["product_boxing_id"], name: "index_carts_on_product_boxing_id", using: :btree
  add_index "carts", ["user_id"], name: "index_carts_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["product_id"], name: "index_comments_on_product_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "delete_c",           default: false, null: false
    t.boolean  "activate_c",         default: true,  null: false
    t.string   "phone_no"
    t.string   "postal"
    t.string   "county"
    t.string   "district"
    t.string   "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "company_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_images", ["company_id"], name: "index_company_images_on_company_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "product_boxings", force: true do |t|
    t.integer  "quantity"
    t.string   "unit"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_boxings", ["product_id"], name: "index_product_boxings_on_product_id", using: :btree

  create_table "product_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_images", ["product_id"], name: "index_product_images_on_product_id", using: :btree

  create_table "product_pricings", force: true do |t|
    t.integer  "quantity"
    t.float    "price",             limit: 24
    t.integer  "product_boxing_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_pricings", ["product_boxing_id"], name: "index_product_pricings_on_product_boxing_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "inventory"
    t.boolean  "delete_c"
    t.boolean  "available_c"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["company_id"], name: "index_products_on_company_id", using: :btree

  create_table "sub_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_comments", ["comment_id"], name: "index_sub_comments_on_comment_id", using: :btree
  add_index "sub_comments", ["user_id"], name: "index_sub_comments_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "delete_c",               default: false, null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
