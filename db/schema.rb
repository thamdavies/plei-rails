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

ActiveRecord::Schema[8.1].define(version: 2026_06_25_020209) do
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

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "permissions", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.string "resource", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_permissions_on_slug", unique: true
  end

  create_table "post_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "tag_id"], name: "index_post_tags_on_post_id_and_tag_id", unique: true
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "body"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.text "summary"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["status"], name: "index_posts_on_status"
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

  create_table "role_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "role_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "confirmation_token", limit: 128
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "remember_token", limit: 128, null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
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

  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "users", column: "author_id"
  add_foreign_key "provinces", "administrative_units"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "wards", "administrative_units"
  add_foreign_key "wards", "provinces", column: "province_code", primary_key: "code"
end
