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

ActiveRecord::Schema.define(version: 2019_09_12_172224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "draft_picks", force: :cascade do |t|
    t.string "team"
    t.integer "year"
    t.integer "round"
    t.integer "tlfl_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "position"
    t.string "nfl_abbrev"
    t.boolean "on_ir", default: false
    t.integer "ir_fd_id"
    t.integer "tlfl_seniority", default: 1
    t.integer "bye_week"
    t.integer "tlfl_team_id"
    t.integer "fd_id"
    t.integer "fd_nfl_id"
    t.integer "cbs_id"
    t.integer "nfl_id"
    t.integer "esb_id"
    t.string "cbs_photo"
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
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
