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

ActiveRecord::Schema.define(version: 20151129034317) do

  create_table "locations", force: :cascade do |t|
    t.string   "host"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ping_results", force: :cascade do |t|
    t.float    "lag_ms"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "user_agent"
    t.integer  "location_id"
    t.integer  "server_location_id"
    t.string   "protocol"
  end

  add_index "ping_results", ["location_id"], name: "index_ping_results_on_location_id"

end
