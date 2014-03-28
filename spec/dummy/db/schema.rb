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

ActiveRecord::Schema.define(version: 20140328154703) do

  create_table "csv_imports", force: true do |t|
    t.string   "file"
    t.string   "file_cache"
    t.integer  "total_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_errors", force: true do |t|
    t.integer  "csv_import_id"
    t.string   "csv_import_type"
    t.text     "error_messages"
    t.text     "input_values"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_errors", ["csv_import_id", "csv_import_type"], name: "index_import_errors_on_csv_import_id_and_csv_import_type"

end
