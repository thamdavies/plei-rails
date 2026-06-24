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

ActiveRecord::Schema[8.1].define(version: 2026_06_24_043405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "administrative_regions", id: :serial, force: :cascade do |t|
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255, null: false
    t.index ["code_name"], name: "index_administrative_regions_on_code_name", unique: true
  end

  create_table "administrative_units", id: :serial, force: :cascade do |t|
    t.string "code_name", limit: 255
    t.string "code_name_en", limit: 255
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "short_name", limit: 255
    t.string "short_name_en", limit: 255
    t.index ["code_name"], name: "index_administrative_units_on_code_name", unique: true
  end

  create_table "provinces", id: false, force: :cascade do |t|
    t.integer "administrative_unit_id"
    t.string "code", limit: 20, null: false
    t.string "code_name", limit: 255
    t.string "full_name", limit: 255, null: false
    t.string "full_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.index ["administrative_unit_id"], name: "index_provinces_on_administrative_unit_id"
    t.index ["code"], name: "index_provinces_on_code", unique: true
    t.index ["code_name"], name: "index_provinces_on_code_name", unique: true
  end

  create_table "wards", id: false, force: :cascade do |t|
    t.integer "administrative_unit_id"
    t.string "code", limit: 20, null: false
    t.string "code_name", limit: 255
    t.string "full_name", limit: 255
    t.string "full_name_en", limit: 255
    t.string "name", limit: 255, null: false
    t.string "name_en", limit: 255
    t.string "province_code", limit: 20
    t.index ["administrative_unit_id"], name: "index_wards_on_administrative_unit_id"
    t.index ["province_code"], name: "index_wards_on_province_code"
  end

  add_foreign_key "provinces", "administrative_units"
  add_foreign_key "wards", "administrative_units"
  add_foreign_key "wards", "provinces", column: "province_code", primary_key: "code"
end
