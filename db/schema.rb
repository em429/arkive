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

ActiveRecord::Schema[7.0].define(version: 2022_11_27_024729) do
  create_table "webpages", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.string "internet_archive_url", default: "https://web.archive.org/web/"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read_status", default: false
    t.text "content"
    t.index ["url"], name: "index_webpages_on_url", unique: true
  end

end
