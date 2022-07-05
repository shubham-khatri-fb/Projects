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

ActiveRecord::Schema.define(version: 2022_07_04_124118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "all_transactions", force: :cascade do |t|
    t.decimal "conversion_rate"
    t.decimal "amount_transfer"
    t.integer "transfer_currency_type"
    t.integer "receive_currency_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_currencies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "currency_type"
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "user_transactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_id_transaction_made"
    t.integer "all_transaction_id"
    t.integer "transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.bigint "phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "authy_id"
    t.string "email"
    t.string "avatar"
    t.string "password_digest"
  end

end
