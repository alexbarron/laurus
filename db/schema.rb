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

ActiveRecord::Schema[7.0].define(version: 2023_11_28_091512) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_invitations", force: :cascade do |t|
    t.integer "inviter_id"
    t.integer "invitee_id"
    t.string "invitee_email"
    t.integer "developer_app_id"
    t.boolean "admin"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["developer_app_id", "invitee_email"], name: "index_app_invitations_on_developer_app_id_and_invitee_email", unique: true
    t.index ["invitee_email"], name: "index_app_invitations_on_invitee_email"
  end

  create_table "app_memberships", force: :cascade do |t|
    t.boolean "admin", default: false
    t.bigint "developer_app_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_app_memberships_on_deleted_at"
    t.index ["developer_app_id", "user_id"], name: "index_app_memberships_on_developer_app_id_and_user_id", unique: true
    t.index ["developer_app_id"], name: "index_app_memberships_on_developer_app_id"
    t.index ["user_id"], name: "index_app_memberships_on_user_id"
  end

  create_table "developer_apps", force: :cascade do |t|
    t.string "name"
    t.string "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived_at"
    t.index ["archived_at"], name: "index_developer_apps_on_archived_at"
  end

  create_table "endpoints", force: :cascade do |t|
    t.string "path"
    t.string "method"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "responses", default: "{}"
    t.jsonb "request_body", default: "{}"
    t.index ["path", "method"], name: "index_endpoints_on_path_and_method", unique: true
    t.index ["request_body"], name: "index_endpoints_on_request_body", using: :gin
    t.index ["responses"], name: "index_endpoints_on_responses", using: :gin
  end

  create_table "grants", force: :cascade do |t|
    t.bigint "endpoint_id", null: false
    t.bigint "developer_app_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["developer_app_id"], name: "index_grants_on_developer_app_id"
    t.index ["endpoint_id", "developer_app_id"], name: "index_grants_on_endpoint_id_and_developer_app_id", unique: true
    t.index ["endpoint_id"], name: "index_grants_on_endpoint_id"
  end

  create_table "parameter_references", force: :cascade do |t|
    t.bigint "endpoint_id", null: false
    t.bigint "parameter_id", null: false
    t.string "description"
  end

  create_table "parameters", force: :cascade do |t|
    t.string "name"
    t.string "data_type"
    t.integer "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schema_references", force: :cascade do |t|
    t.integer "referenced_id"
    t.integer "endpoint_id"
    t.integer "schema_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schemas", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "description"
    t.string "data_type"
    t.jsonb "properties", default: "{}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["properties"], name: "index_schemas_on_properties", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "platform_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "app_memberships", "developer_apps"
  add_foreign_key "app_memberships", "users"
  add_foreign_key "grants", "developer_apps"
  add_foreign_key "grants", "endpoints"
end
