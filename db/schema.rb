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

ActiveRecord::Schema[7.0].define(version: 2024_08_19_154150) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "admins_schools", id: false, force: :cascade do |t|
    t.string "school_id"
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_admins_schools_on_admin_id"
    t.index ["school_id"], name: "index_admins_schools_on_school_id"
  end

  create_table "cached_urls", force: :cascade do |t|
    t.string "url"
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_subscriptions", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "subscribable_type"
    t.string "subscribable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_subscriptions_on_device_id"
    t.index ["subscribable_type", "subscribable_id"], name: "index_device_subscriptions_on_subscribable"
  end

  create_table "devices", force: :cascade do |t|
    t.string "device_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "event_type"
    t.datetime "start"
    t.boolean "tba"
    t.string "result_type"
    t.boolean "conference"
    t.boolean "scrimmage"
    t.boolean "location_verified"
    t.boolean "canceled"
    t.boolean "postponed"
    t.string "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location_name"
    t.bigint "import_source_id"
    t.index ["import_source_id"], name: "index_events_on_import_source_id"
    t.index ["location_id"], name: "index_events_on_location_id"
  end

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", id: :string, force: :cascade do |t|
    t.string "url"
    t.string "description"
    t.string "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_images_on_team_id"
  end

  create_table "import_sources", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "school_id", null: false
    t.bigint "sport_id"
    t.bigint "gender_id"
    t.bigint "level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_import_time"
    t.integer "frequency_hours", default: 24, null: false
    t.bigint "year_id", null: false
    t.index ["gender_id"], name: "index_import_sources_on_gender_id"
    t.index ["level_id"], name: "index_import_sources_on_level_id"
    t.index ["school_id"], name: "index_import_sources_on_school_id"
    t.index ["sport_id"], name: "index_import_sources_on_sport_id"
    t.index ["year_id"], name: "index_import_sources_on_year_id"
  end

  create_table "integration_tokens", force: :cascade do |t|
    t.string "integration_name"
    t.string "access_token"
    t.string "token_type"
    t.string "scope"
    t.integer "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "plus_4"
    t.string "timezone"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "grad_year"
    t.string "jersey"
    t.string "position"
    t.string "height"
    t.string "weight"
    t.string "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "pressbox_posts", id: false, force: :cascade do |t|
    t.string "id", null: false
    t.boolean "is_visible"
    t.datetime "created"
    t.datetime "modified"
    t.string "created_by"
    t.string "modified_by"
    t.datetime "submitted"
    t.string "submitted_by"
    t.string "title"
    t.text "recap"
    t.text "boxscore"
    t.boolean "website_only"
    t.string "featured_image"
    t.string "event_id"
    t.string "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_pressbox_posts_on_event_id"
    t.index ["team_id"], name: "index_pressbox_posts_on_team_id"
  end

  create_table "programs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "name_slug"
    t.string "school_id", null: false
    t.bigint "gender_id", null: false
    t.bigint "sport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gender_id"], name: "index_programs_on_gender_id"
    t.index ["school_id"], name: "index_programs_on_school_id"
    t.index ["sport_id"], name: "index_programs_on_sport_id"
  end

  create_table "results", force: :cascade do |t|
    t.integer "away"
    t.integer "home"
    t.string "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_results_on_event_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at", precision: nil
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at", precision: nil
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after", precision: nil
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.boolean "sound_is_json", default: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "schedule_providers", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "login_url"
    t.integer "supported_by_vnn"
    t.boolean "has_conference"
    t.boolean "has_location_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedule_sources", force: :cascade do |t|
    t.string "url"
    t.datetime "last_update"
    t.datetime "last_sync_request"
    t.bigint "schedule_provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["schedule_provider_id"], name: "index_schedule_sources_on_schedule_provider_id"
  end

  create_table "schools", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "mascot"
    t.boolean "is_vnn"
    t.string "url"
    t.string "logo_url"
    t.text "anti_discrimination_disclaimer"
    t.text "registration_text"
    t.string "registration_url"
    t.string "primary_color"
    t.string "secondary_color"
    t.string "tertiary_color"
    t.integer "enrollment"
    t.string "athletic_director"
    t.string "phone"
    t.string "email"
    t.integer "blog"
    t.integer "sportshub_version"
    t.integer "version"
    t.string "instagram_url"
    t.string "onboarding"
    t.boolean "visible", default: false
    t.string "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitter_url"
    t.string "facebook_url"
    t.index ["location_id"], name: "index_schools_on_location_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.string "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_events", force: :cascade do |t|
    t.string "event_id", null: false
    t.string "team_id", null: false
    t.text "private_notes"
    t.text "public_notes"
    t.datetime "bus_dismissal_datetime_local"
    t.datetime "bus_departure_datetime_local"
    t.datetime "bus_return_datetime_local"
    t.boolean "home"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "opponent_name"
    t.index ["event_id"], name: "index_team_events_on_event_id"
    t.index ["team_id"], name: "index_team_events_on_team_id"
  end

  create_table "team_results", force: :cascade do |t|
    t.string "team_id"
    t.string "name"
    t.integer "place"
    t.integer "points"
    t.string "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_team_results_on_event_id"
    t.index ["team_id"], name: "index_team_results_on_team_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.string "photo_url"
    t.text "home_description"
    t.boolean "hide_gender"
    t.string "program_id"
    t.bigint "schedule_source_id"
    t.bigint "year_id"
    t.bigint "season_id"
    t.bigint "level_id"
    t.string "school_id"
    t.bigint "gender_id"
    t.bigint "sport_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gender_id"], name: "index_teams_on_gender_id"
    t.index ["level_id"], name: "index_teams_on_level_id"
    t.index ["program_id"], name: "index_teams_on_program_id"
    t.index ["schedule_source_id"], name: "index_teams_on_schedule_source_id"
    t.index ["school_id"], name: "index_teams_on_school_id"
    t.index ["season_id"], name: "index_teams_on_season_id"
    t.index ["sport_id"], name: "index_teams_on_sport_id"
    t.index ["year_id"], name: "index_teams_on_year_id"
  end

  create_table "years", force: :cascade do |t|
    t.string "name"
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "device_subscriptions", "devices"
  add_foreign_key "events", "import_sources"
  add_foreign_key "events", "locations"
  add_foreign_key "images", "teams"
  add_foreign_key "import_sources", "genders"
  add_foreign_key "import_sources", "levels"
  add_foreign_key "import_sources", "schools"
  add_foreign_key "import_sources", "sports"
  add_foreign_key "import_sources", "years"
  add_foreign_key "players", "teams"
  add_foreign_key "pressbox_posts", "events"
  add_foreign_key "pressbox_posts", "teams"
  add_foreign_key "programs", "genders"
  add_foreign_key "programs", "schools"
  add_foreign_key "programs", "sports"
  add_foreign_key "results", "events"
  add_foreign_key "schedule_sources", "schedule_providers"
  add_foreign_key "schools", "locations"
  add_foreign_key "team_events", "events"
  add_foreign_key "team_events", "teams"
  add_foreign_key "team_results", "events"
  add_foreign_key "team_results", "teams"
  add_foreign_key "teams", "genders"
  add_foreign_key "teams", "levels"
  add_foreign_key "teams", "programs"
  add_foreign_key "teams", "schedule_sources"
  add_foreign_key "teams", "schools"
  add_foreign_key "teams", "seasons"
  add_foreign_key "teams", "sports"
  add_foreign_key "teams", "years"
end
