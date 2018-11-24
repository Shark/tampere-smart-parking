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

ActiveRecord::Schema.define(version: 2018_11_24_191223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caches", force: :cascade do |t|
    t.string "key"
    t.json "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_caches_on_key", unique: true
  end

  create_table "parking_spots", force: :cascade do |t|
    t.decimal "latitude", precision: 9, scale: 6
    t.decimal "longitude", precision: 9, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.string "status", default: "free"
    t.json "polygon"
    t.string "friendly_name"
    t.datetime "last_confirmed_free_at"
    t.index ["friendly_name"], name: "index_parking_spots_on_friendly_name", unique: true
  end

end
