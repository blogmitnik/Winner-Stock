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

ActiveRecord::Schema.define(version: 2020_07_01_041056) do

  create_table "categories", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "source_file_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name"
    t.index ["post_id"], name: "index_categories_on_post_id"
    t.index ["source_file_id"], name: "index_categories_on_source_file_id"
  end

  create_table "friendly_id_slugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.string "locale"
    t.datetime "created_at"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale", length: { slug: 140, locale: 2 }
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_uniqueness", unique: true, length: { slug: 70, scope: 70, locale: 2 }
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "mi_reports", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "source_file_id", null: false
    t.string "category_id", null: false
    t.string "stock_code", null: false
    t.string "stock_name", null: false
    t.bigint "traded_volume", null: false
    t.bigint "total_transactions", null: false
    t.bigint "turnover", null: false
    t.float "opening_price"
    t.float "highest_price"
    t.float "lowest_price"
    t.float "closing_price"
    t.string "ups_and_downs", null: false
    t.float "change", null: false
    t.float "last_best_bid_price"
    t.integer "last_best_bid_qty"
    t.float "last_best_ask_price"
    t.float "last_best_ask_qty"
    t.float "pice_earnings_ratio"
    t.float "shares_percentage", null: false
    t.float "closing_percentage", null: false
    t.datetime "published_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id", "published_at"], name: "index_mi_reports_on_category_id_and_published_at"
    t.index ["category_id"], name: "index_mi_reports_on_category_id"
    t.index ["closing_percentage"], name: "index_mi_reports_on_closing_percentage"
    t.index ["closing_price"], name: "index_mi_reports_on_closing_price"
    t.index ["highest_price"], name: "index_mi_reports_on_highest_price"
    t.index ["last_best_ask_price"], name: "index_mi_reports_on_last_best_ask_price"
    t.index ["last_best_ask_qty"], name: "index_mi_reports_on_last_best_ask_qty"
    t.index ["last_best_bid_price"], name: "index_mi_reports_on_last_best_bid_price"
    t.index ["last_best_bid_qty"], name: "index_mi_reports_on_last_best_bid_qty"
    t.index ["lowest_price"], name: "index_mi_reports_on_lowest_price"
    t.index ["opening_price"], name: "index_mi_reports_on_opening_price"
    t.index ["pice_earnings_ratio"], name: "index_mi_reports_on_pice_earnings_ratio"
    t.index ["post_id"], name: "index_mi_reports_on_post_id"
    t.index ["published_at"], name: "index_mi_reports_on_published_at"
    t.index ["shares_percentage"], name: "index_mi_reports_on_shares_percentage"
    t.index ["source_file_id"], name: "index_mi_reports_on_source_file_id"
    t.index ["stock_code", "stock_name"], name: "index_mi_reports_on_stock_code_and_stock_name"
    t.index ["stock_code"], name: "index_mi_reports_on_stock_code"
    t.index ["stock_name"], name: "index_mi_reports_on_stock_name"
    t.index ["total_transactions"], name: "index_mi_reports_on_total_transactions"
    t.index ["traded_volume"], name: "index_mi_reports_on_traded_volume"
    t.index ["turnover"], name: "index_mi_reports_on_turnover"
  end

  create_table "oauth_access_grants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "posts", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.integer "current_year"
    t.integer "current_month"
    t.integer "current_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["current_date"], name: "index_posts_on_current_date"
    t.index ["current_month"], name: "index_posts_on_current_month"
    t.index ["current_year", "current_month", "current_date"], name: "index_posts_on_current_year_and_current_month_and_current_date"
    t.index ["current_year"], name: "index_posts_on_current_year"
    t.index ["slug"], name: "index_posts_on_slug"
    t.index ["title"], name: "index_posts_on_title"
  end

  create_table "reports", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "source_file_id", null: false
    t.string "category_id", null: false
    t.string "category_name", null: false
    t.bigint "traded_shares_num", null: false
    t.bigint "turnover", null: false
    t.bigint "total_transactions", null: false
    t.decimal "advance_decline_idx", precision: 5, scale: 2, null: false
    t.float "shares_percentage", null: false
    t.float "closing_percentage", null: false
    t.datetime "published_at", null: false
    t.integer "p_year", null: false
    t.integer "p_month", null: false
    t.integer "p_date", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["advance_decline_idx"], name: "index_reports_on_advance_decline_idx"
    t.index ["category_id", "p_year", "p_month", "p_date"], name: "index_reports_on_category_id_and_p_year_and_p_month_and_p_date"
    t.index ["category_id", "published_at"], name: "index_reports_on_category_id_and_published_at"
    t.index ["category_id"], name: "index_reports_on_category_id"
    t.index ["category_name", "p_year", "p_month", "p_date"], name: "index_reports_on_category_name_and_p_year_and_p_month_and_p_date"
    t.index ["category_name", "published_at"], name: "index_reports_on_category_name_and_published_at"
    t.index ["category_name"], name: "index_reports_on_category_name"
    t.index ["p_year", "p_month", "p_date"], name: "index_reports_on_p_year_and_p_month_and_p_date"
    t.index ["post_id"], name: "index_reports_on_post_id"
    t.index ["published_at"], name: "index_reports_on_published_at"
    t.index ["source_file_id"], name: "index_reports_on_source_file_id"
    t.index ["total_transactions"], name: "index_reports_on_total_transactions"
    t.index ["traded_shares_num"], name: "index_reports_on_traded_shares_num"
    t.index ["turnover"], name: "index_reports_on_turnover"
  end

  create_table "source_files", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "post_id", null: false
    t.string "file_name", null: false
    t.integer "total_row", null: false
    t.datetime "published_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["file_name"], name: "index_source_files_on_file_name", unique: true
    t.index ["post_id"], name: "index_source_files_on_post_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.string "name"
    t.boolean "admin", default: false
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "superadmin_role", default: false
    t.boolean "supervisor_role", default: false
    t.boolean "user_role", default: true
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
