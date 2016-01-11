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

ActiveRecord::Schema.define(version: 20160105032841) do

  create_table "gamematches", force: :cascade do |t|
    t.integer  "matchnum"
    t.string   "wchar"
    t.string   "lchar"
    t.string   "winner_id"
    t.string   "loser_id"
    t.string   "map"
    t.boolean  "invalidMatch"
    t.integer  "gameset_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "gamematches", ["gameset_id"], name: "index_gamematches_on_gameset_id"
  add_index "gamematches", ["tournament_id"], name: "index_gamematches_on_tournament_id"

  create_table "gamematches_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "gamematch_id"
  end

  add_index "gamematches_players", ["gamematch_id"], name: "index_gamematches_players_on_gamematch_id"
  add_index "gamematches_players", ["player_id"], name: "index_gamematches_players_on_player_id"

  create_table "gamesets", force: :cascade do |t|
    t.integer  "roundNum"
    t.string   "winner_id"
    t.string   "loser_id"
    t.string   "topPlayer_id"
    t.string   "bottomPlayer_id"
    t.string   "url"
    t.integer  "setnum"
    t.integer  "wscore"
    t.integer  "lscore"
    t.integer  "tournament_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "gamesets", ["tournament_id"], name: "index_gamesets_on_tournament_id"

  create_table "gamesets_players", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "gameset_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players_tournaments", id: false, force: :cascade do |t|
    t.integer "player_id"
    t.integer "tournament_id"
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
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
