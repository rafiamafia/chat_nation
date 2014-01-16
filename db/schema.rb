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

ActiveRecord::Schema.define(version: 20140113030118) do

  create_table "chat_rooms", force: true do |t|
    t.string   "title"
    t.integer  "initiating_user_id"
    t.boolean  "active",             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_rooms_users", id: false, force: true do |t|
    t.integer "chat_room_id", null: false
    t.integer "user_id",      null: false
  end

  add_index "chat_rooms_users", ["chat_room_id", "user_id"], name: "index_chat_rooms_users_on_chat_room_id_and_user_id", using: :btree
  add_index "chat_rooms_users", ["user_id", "chat_room_id"], name: "index_chat_rooms_users_on_user_id_and_chat_room_id", using: :btree

  create_table "event_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "initiating_user_id"
    t.integer  "receiving_user_id"
    t.integer  "event_type_id"
    t.integer  "chat_room_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["chat_room_id"], name: "index_events_on_chat_room_id", using: :btree
  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
  add_index "events", ["initiating_user_id"], name: "index_events_on_initiating_user_id", using: :btree
  add_index "events", ["receiving_user_id"], name: "index_events_on_receiving_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
