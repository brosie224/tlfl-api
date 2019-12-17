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

ActiveRecord::Schema.define(version: 2019_12_17_164633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: :cascade do |t|
    t.string "team"
    t.integer "year"
    t.integer "round"
    t.integer "tlfl_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "overall"
  end

  create_table "owners", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.integer "tlfl_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_games", force: :cascade do |t|
    t.integer "season"
    t.integer "season_type"
    t.integer "week"
    t.string "player_name"
    t.string "nfl_team"
    t.string "tlfl_team_id"
    t.string "position"
    t.boolean "needs_replacement", default: false
    t.integer "pass_comp", default: 0
    t.integer "pass_att", default: 0
    t.integer "pass_yards", default: 0
    t.integer "pass_td", default: 0
    t.integer "pass_int", default: 0
    t.integer "rushes", default: 0
    t.integer "rush_yards", default: 0
    t.integer "rush_td", default: 0
    t.integer "receptions", default: 0
    t.integer "rec_yards", default: 0
    t.integer "rec_td", default: 0
    t.integer "punt_ret_td", default: 0
    t.integer "kick_ret_td", default: 0
    t.integer "two_pt_pass", default: 0
    t.integer "two_pt_rush", default: 0
    t.integer "two_pt_rec", default: 0
    t.integer "fgm", default: 0
    t.integer "fga", default: 0
    t.integer "pat", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player_id"
    t.integer "manual_pts"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "position"
    t.string "nfl_abbrev"
    t.integer "ir_id"
    t.integer "seniority", default: 1
    t.integer "bye_week"
    t.integer "tlfl_team_id"
    t.integer "fd_id"
    t.integer "fd_nfl_id"
    t.integer "cbs_id"
    t.integer "nfl_id"
    t.string "esb_id"
    t.integer "jersey"
    t.integer "ir_week"
    t.boolean "available", default: true
  end

  create_table "reserves", force: :cascade do |t|
    t.integer "week"
    t.string "named_player"
    t.string "replacement_player"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "season"
  end

  create_table "schedule_games", force: :cascade do |t|
    t.integer "pfb_id"
    t.string "home_team"
    t.string "away_team"
    t.integer "season"
    t.integer "week"
    t.integer "month"
    t.integer "day"
    t.string "season_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_dst_games", force: :cascade do |t|
    t.integer "team_dst_id"
    t.string "team_name"
    t.integer "tlfl_team_id"
    t.integer "season"
    t.integer "season_type"
    t.integer "week"
    t.string "nfl_abbrev"
    t.integer "points_allowed", default: 99
    t.integer "touchdowns", default: 0
    t.integer "sacks", default: 0
    t.integer "fumbles_recovered", default: 0
    t.integer "interceptions", default: 0
    t.integer "safeties", default: 0
    t.integer "two_pt_ret", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "manual_pts"
  end

  create_table "team_dsts", force: :cascade do |t|
    t.string "city"
    t.string "nickname"
    t.integer "bye_week"
    t.string "logo"
    t.string "word_mark"
    t.integer "tlfl_team_id"
    t.integer "fd_id"
    t.integer "fd_player_id"
    t.integer "nfl_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nfl_abbrev"
  end

  create_table "tlfl_teams", force: :cascade do |t|
    t.string "city"
    t.string "nickname"
    t.string "conference"
    t.string "division"
    t.integer "bye_week"
    t.string "abbreviation"
    t.integer "fd_id"
    t.integer "nfl_id"
    t.string "logo"
    t.string "word_mark"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "tertiary_color"
    t.string "quaternary_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "protections", default: 3
  end

  create_table "trades", force: :cascade do |t|
    t.integer "season"
    t.integer "week"
    t.integer "team_one"
    t.integer "team_two"
    t.text "players_one", default: [], array: true
    t.text "players_two", default: [], array: true
    t.boolean "includes_protection_one"
    t.boolean "includes_protection_two"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dst_one"
    t.integer "dst_two"
    t.text "picks_one", default: [], array: true
    t.text "picks_two", default: [], array: true
    t.integer "team_one_total"
    t.integer "team_two_total"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
