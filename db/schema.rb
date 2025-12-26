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

ActiveRecord::Schema[8.0].define(version: 2025_12_25_145424) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_stats", force: :cascade do |t|
    t.bigint "steam_user_id", null: false
    t.integer "app_id", null: false
    t.string "stat_name"
    t.bigint "stat_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["steam_user_id"], name: "index_game_stats_on_steam_user_id"
  end

  create_table "spotify_users", force: :cascade do |t|
    t.string "display_name"
    t.string "profile_image_url"
    t.string "spotify_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_spotify_users_on_user_id", unique: true
  end

  create_table "steam_users", force: :cascade do |t|
    t.string "steam_id"
    t.string "name"
    t.string "profile_image_url"
    t.string "profile_url"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_level"
    t.integer "last_log_off"
    t.integer "time_created"
    t.string "loc_country_code"
    t.index ["user_id"], name: "index_steam_users_on_user_id", unique: true
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
    t.string "artist_name"
    t.index ["spotify_user_id"], name: "index_top_songs_on_spotify_user_id"
  end

  create_table "user_games", force: :cascade do |t|
    t.integer "app_id"
    t.string "name"
    t.integer "playtime_forever"
    t.string "img_icon_url"
    t.integer "rtime_last_played"
    t.bigint "steam_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["steam_user_id"], name: "index_user_games_on_steam_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "game_stats", "steam_users"
  add_foreign_key "spotify_users", "users"
  add_foreign_key "steam_users", "users"
  add_foreign_key "top_artists", "spotify_users"
  add_foreign_key "top_songs", "spotify_users"
  add_foreign_key "user_games", "steam_users"
end
