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

ActiveRecord::Schema.define(version: 20160208010617) do

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  add_index "admins", ["username"], name: "index_admins_on_username", unique: true

  create_table "gamematches", force: :cascade do |t|
    t.integer  "matchnum"
    t.string   "wchar"
    t.string   "lchar"
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.string   "map"
    t.boolean  "invalidMatch"
    t.integer  "gameset_id"
    t.integer  "tournament_id"
    t.string   "create_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "gamematches", ["gameset_id"], name: "index_gamematches_on_gameset_id"
  add_index "gamematches", ["tournament_id"], name: "index_gamematches_on_tournament_id"

  create_table "gamematches_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "gamematch_id"
    t.string  "create_user_id"
  end

  add_index "gamematches_players", ["gamematch_id"], name: "index_gamematches_players_on_gamematch_id"
  add_index "gamematches_players", ["player_id"], name: "index_gamematches_players_on_player_id"

  create_table "gamesets", force: :cascade do |t|
    t.integer  "winner_id"
    t.integer  "loser_id"
    t.integer  "topPlayer_id"
    t.integer  "bottomPlayer_id"
    t.integer  "toWinnerSet_id"
    t.integer  "toLoserSet_id"
    t.string   "url"
    t.integer  "setnum"
    t.integer  "wscore"
    t.integer  "lscore"
    t.integer  "tournament_id"
    t.string   "create_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "roundnum"
  end

  add_index "gamesets", ["tournament_id"], name: "index_gamesets_on_tournament_id"

  create_table "gamesets_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "gameset_id"
    t.string  "create_user_id"
  end

  add_index "gamesets_players", ["gameset_id"], name: "index_gamesets_players_on_gameset_id"
  add_index "gamesets_players", ["player_id"], name: "index_gamesets_players_on_player_id"

  create_table "players", force: :cascade do |t|
    t.string   "gamertag"
    t.string   "name"
    t.string   "characters"
    t.integer  "wins"
    t.integer  "loses"
    t.integer  "winrate"
    t.string   "create_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "players_tournaments", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "tournament_id"
    t.string  "create_user_id"
  end

  add_index "players_tournaments", ["player_id"], name: "index_players_tournaments_on_player_id"
  add_index "players_tournaments", ["tournament_id"], name: "index_players_tournaments_on_tournament_id"

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.string   "description"
    t.string   "url"
    t.integer  "winnersRounds"
    t.integer  "losersRounds"
    t.boolean  "isIntegration"
    t.string   "create_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
