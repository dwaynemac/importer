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

ActiveRecord::Schema.define(version: 20140318133133) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_modules", force: true do |t|
    t.integer "import_id"
    t.string  "name"
    t.string  "status",      default: "ready"
    t.string  "status_url"
    t.string  "type"
    t.boolean "failed_rows"
  end

  create_table "imports", force: true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "import_file"
    t.string   "status",        default: "ready"
    t.string   "source_system"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.integer  "current_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
