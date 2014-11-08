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

ActiveRecord::Schema.define(version: 20141108230715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "spot_feeds", force: true do |t|
    t.string   "feed_id"
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.integer  "usage"
    t.integer  "days_range"
    t.boolean  "detailed_message_shown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sync"
    t.string   "sync_status"
    t.integer  "spot_group_id"
  end

  add_index "spot_feeds", ["feed_id"], name: "index_spot_feeds_on_feed_id", unique: true, using: :btree

  create_table "spot_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spot_messages", force: true do |t|
    t.integer  "spot_feed_id"
    t.integer  "spot_id"
    t.string   "messenger_id"
    t.string   "messenger_name"
    t.integer  "unix_time"
    t.string   "message_type"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "model_id"
    t.string   "show_custom_msg"
    t.datetime "date_time"
    t.integer  "hidden"
    t.string   "message_content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "battery_state"
  end

  add_index "spot_messages", ["spot_feed_id"], name: "index_spot_messages_on_spot_feed_id", using: :btree
  add_index "spot_messages", ["spot_id"], name: "index_spot_messages_on_spot_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
