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

ActiveRecord::Schema[8.0].define(version: 2025_11_25_124353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "spotify_users", force: :cascade do |t|
    t.string "display_name"
    t.string "profile_image_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_spotify_users_on_user_id", unique: true
  end

  create_table "top_artists", force: :cascade do |t|
    t.string "name"
    t.string "spotify_id"
    t.string "image_url"
    t.string "period"
    t.integer "rank"
    t.bigint "spotify_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spotify_user_id"], name: "index_top_artists_on_spotify_user_id"
  end

  create_table "top_songs", force: :cascade do |t|
    t.string "name"
    t.string "album_name"
    t.string "spotify_id"
    t.string "image_url"
    t.string "period"
    t.integer "rank"
    t.bigint "spotify_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spotify_user_id"], name: "index_top_songs_on_spotify_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "spotify_users", "users"
  add_foreign_key "top_artists", "spotify_users"
  add_foreign_key "top_songs", "spotify_users"
end
