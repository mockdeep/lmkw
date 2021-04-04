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

ActiveRecord::Schema.define(version: 2021_04_04_221132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
    t.index ["value"], name: "index_api_keys_on_value", unique: true
  end

  create_table "check_counts", force: :cascade do |t|
    t.bigint "check_id", null: false
    t.bigint "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["check_id"], name: "index_check_counts_on_check_id"
  end

  create_table "check_targets", force: :cascade do |t|
    t.bigint "value", null: false
    t.bigint "check_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delta", null: false
    t.bigint "goal_value", null: false
    t.datetime "next_refresh_at", null: false
    t.index ["check_id"], name: "index_check_targets_on_check_id", unique: true
  end

  create_table "checks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "integration_id", null: false
    t.string "name", null: false
    t.jsonb "data", default: {}, null: false
    t.string "type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "latest_count_id"
    t.index ["integration_id"], name: "index_checks_on_integration_id"
    t.index ["latest_count_id"], name: "index_checks_on_latest_count_id"
    t.index ["user_id", "name"], name: "index_checks_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_checks_on_user_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type", null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["type"], name: "index_integrations_on_type"
    t.index ["user_id", "type"], name: "index_integrations_on_user_id_and_type", unique: true
    t.index ["user_id"], name: "index_integrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "check_counts", "checks"
  add_foreign_key "check_targets", "checks"
  add_foreign_key "checks", "check_counts", column: "latest_count_id"
  add_foreign_key "checks", "integrations"
  add_foreign_key "checks", "users"
  add_foreign_key "integrations", "users"
end
