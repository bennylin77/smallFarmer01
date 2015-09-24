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

ActiveRecord::Schema.define(version: 20150924130615) do

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "phone_no"
    t.string   "postal"
    t.string   "county"
    t.string   "district"
    t.string   "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bills", force: true do |t|
    t.integer  "company_id"
    t.string   "title"
    t.string   "user_first_name"
    t.string   "user_last_name"
    t.string   "company_name"
    t.string   "company_phone_no"
    t.string   "company_postal"
    t.string   "company_county"
    t.string   "company_district"
    t.string   "company_address"
    t.string   "company_country"
    t.string   "bank_code"
    t.string   "bank_account"
    t.float    "total_sales",               limit: 24, default: 0.0, null: false
    t.float    "total_shipping_fees",       limit: 24, default: 0.0, null: false
    t.float    "total_cash_flow_fees",      limit: 24, default: 0.0, null: false
    t.float    "total_administration_fees", limit: 24, default: 0.0, null: false
    t.float    "total_coupon_fees",         limit: 24, default: 0.0, null: false
    t.float    "sales_tax",                 limit: 24, default: 0.0, null: false
    t.float    "transfer_fee",              limit: 24, default: 0.0, null: false
    t.datetime "begin_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bills", ["company_id"], name: "index_bills_on_company_id", using: :btree

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
    t.integer  "user_id"
    t.boolean  "deleted_c",                  default: false, null: false
    t.boolean  "activated_c",                default: true,  null: false
    t.datetime "activated_at"
    t.string   "phone_no"
    t.string   "postal"
    t.string   "county"
    t.string   "district"
    t.string   "address"
    t.string   "country"
    t.string   "bank_code"
    t.string   "bank_account"
    t.string   "name"
    t.text     "description"
    t.text     "words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accept_the_terms_of_use_c",  default: false, null: false
    t.datetime "accept_the_terms_of_use_at"
    t.integer  "priority",                   default: 0,     null: false
    t.boolean  "applied_c",                  default: false, null: false
    t.datetime "applied_at"
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

  create_table "coupons", force: true do |t|
    t.float    "amount",          limit: 24
    t.float    "original_amount", limit: 24
    t.integer  "kind"
    t.boolean  "available_c",                default: true, null: false
    t.integer  "user_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["invoice_id"], name: "index_coupons_on_invoice_id", using: :btree
  add_index "coupons", ["user_id"], name: "index_coupons_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invoice_coupon_lists", force: true do |t|
    t.float    "amount",     limit: 24
    t.integer  "invoice_id"
    t.integer  "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_coupon_lists", ["coupon_id"], name: "index_invoice_coupon_lists_on_coupon_id", using: :btree
  add_index "invoice_coupon_lists", ["invoice_id"], name: "index_invoice_coupon_lists_on_invoice_id", using: :btree

  create_table "invoices", force: true do |t|
    t.integer  "user_id"
    t.boolean  "confirmed_c",                         default: false, null: false
    t.boolean  "canceled_c",                          default: false, null: false
    t.datetime "canceled_at"
    t.boolean  "paid_c",                              default: false, null: false
    t.datetime "paid_at"
    t.float    "payment_charge_fee",       limit: 24, default: 0.0,   null: false
    t.string   "allpay_trade_no"
    t.string   "allpay_merchant_trade_no"
    t.string   "allpay_bank_code"
    t.string   "allpay_v_account"
    t.datetime "allpay_expired_at"
    t.string   "allpay_payment_no"
    t.integer  "payment_method"
    t.float    "amount",                   limit: 24, default: 0.0,   null: false
    t.string   "receipt_c",                           default: "0",   null: false
    t.string   "receipt_received_from"
    t.string   "receipt_VAT_no"
    t.string   "receipt_postal"
    t.string   "receipt_county"
    t.string   "receipt_district"
    t.string   "receipt_address"
    t.string   "receipt_country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "keyword_product_lists", force: true do |t|
    t.integer  "product_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keyword_product_lists", ["keyword_id"], name: "index_keyword_product_lists_on_keyword_id", using: :btree
  add_index "keyword_product_lists", ["product_id"], name: "index_keyword_product_lists_on_product_id", using: :btree

  create_table "keywords", force: true do |t|
    t.string   "content"
    t.integer  "kind",         default: 0, null: false
    t.integer  "search_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "category"
    t.integer  "sub_category"
    t.string   "content"
    t.boolean  "read_c",         default: false, null: false
    t.datetime "read_at"
    t.integer  "order_id"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "sub_comment_id"
    t.integer  "product_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["comment_id"], name: "index_notifications_on_comment_id", using: :btree
  add_index "notifications", ["invoice_id"], name: "index_notifications_on_invoice_id", using: :btree
  add_index "notifications", ["order_id"], name: "index_notifications_on_order_id", using: :btree
  add_index "notifications", ["product_id"], name: "index_notifications_on_product_id", using: :btree
  add_index "notifications", ["sub_comment_id"], name: "index_notifications_on_sub_comment_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "product_boxing_id"
    t.integer  "invoice_id"
    t.integer  "bill_id"
    t.float    "price",                 limit: 24
    t.integer  "quantity"
    t.float    "shipping_rates",        limit: 24
    t.integer  "cold_chain"
    t.integer  "size"
    t.integer  "review_score"
    t.integer  "shipment_review_score"
    t.string   "review_feedback"
    t.datetime "review_at"
    t.boolean  "canceled_c",                       default: false, null: false
    t.datetime "canceled_at"
    t.boolean  "called_smallfarmer_c",             default: false, null: false
    t.datetime "called_smallfarmer_at"
    t.boolean  "called_logistics_c",               default: false, null: false
    t.datetime "called_logistics_at"
    t.boolean  "problem_c",                        default: false, null: false
    t.datetime "problem_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["bill_id"], name: "index_orders_on_bill_id", using: :btree
  add_index "orders", ["invoice_id"], name: "index_orders_on_invoice_id", using: :btree
  add_index "orders", ["product_boxing_id"], name: "index_orders_on_product_boxing_id", using: :btree

  create_table "product_boxings", force: true do |t|
    t.float    "quantity",   limit: 24
    t.integer  "size"
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
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "inventory"
    t.integer  "daily_capacity"
    t.datetime "released_at"
    t.integer  "unit"
    t.boolean  "deleted_c",                        default: false, null: false
    t.datetime "deleted_at"
    t.boolean  "available_c",                      default: false, null: false
    t.datetime "available_at"
    t.integer  "cold_chain"
    t.integer  "size"
    t.integer  "company_id"
    t.text     "preservation"
    t.integer  "sweet_degree"
    t.boolean  "GAP_c",                            default: false, null: false
    t.boolean  "TAP_c",                            default: false, null: false
    t.boolean  "OTAP_c",                           default: false, null: false
    t.boolean  "UTAP_c",                           default: false, null: false
    t.boolean  "pesticide_zero_c",                 default: false, null: false
    t.boolean  "pesticide_qualified_c",            default: false, null: false
    t.string   "short_URL"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority",                         default: 0,     null: false
    t.float    "discount",              limit: 24, default: 1.0,   null: false
    t.integer  "shipping_time",                    default: 0,     null: false
  end

  add_index "products", ["company_id"], name: "index_products_on_company_id", using: :btree

  create_table "receiver_addresses", force: true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "phone_no"
    t.string   "postal"
    t.string   "county"
    t.string   "district"
    t.string   "address"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                              default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                             default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",                                                   null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",                                                 null: false
    t.integer  "retries",                            default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                         default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree
  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", using: :btree

  create_table "shipments", force: true do |t|
    t.integer  "order_id"
    t.integer  "receiver_address_id"
    t.integer  "quantity"
    t.integer  "status"
    t.string   "tracing_code"
    t.integer  "t_cat_status"
    t.datetime "t_cat_status_updated_at"
    t.boolean  "delivered_c",             default: false, null: false
    t.datetime "delivered_at"
    t.integer  "delivery_interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipments", ["order_id"], name: "index_shipments_on_order_id", using: :btree
  add_index "shipments", ["receiver_address_id"], name: "index_shipments_on_receiver_address_id", using: :btree

  create_table "sub_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_comments", ["comment_id"], name: "index_sub_comments_on_comment_id", using: :btree
  add_index "sub_comments", ["user_id"], name: "index_sub_comments_on_user_id", using: :btree

  create_table "user_devices", force: true do |t|
    t.integer  "user_id"
    t.integer  "os"
    t.string   "device_token"
    t.string   "registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_devices", ["device_token"], name: "index_user_devices_on_device_token", unique: true, using: :btree
  add_index "user_devices", ["registration_id"], name: "index_user_devices_on_registration_id", unique: true, using: :btree
  add_index "user_devices", ["user_id"], name: "index_user_devices_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                           default: "",    null: false
    t.string   "encrypted_password",              default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "phone_no"
    t.string   "phone_no_for_confirmation"
    t.string   "phone_no_confirmation_token"
    t.datetime "phone_no_confirmed_at"
    t.integer  "phone_no_confirmation_frequency", default: 0,     null: false
    t.string   "referral_code"
    t.boolean  "deleted_c",                       default: false, null: false
    t.boolean  "blocked_c",                       default: false, null: false
    t.datetime "blocked_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.datetime "authentication_token_expires_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["referral_code"], name: "index_users_on_referral_code", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
