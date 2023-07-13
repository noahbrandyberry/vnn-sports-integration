class ChangeIdsToStrings < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key "device_subscriptions", "devices"
    remove_foreign_key "events", "locations"
    remove_foreign_key "pressbox_posts", "events"
    remove_foreign_key "pressbox_posts", "teams"
    remove_foreign_key "programs", "genders"
    remove_foreign_key "programs", "schools"
    remove_foreign_key "programs", "sports"
    remove_foreign_key "results", "events"
    remove_foreign_key "schedule_sources", "schedule_providers"
    remove_foreign_key "schools", "locations"
    remove_foreign_key "team_events", "events"
    remove_foreign_key "team_events", "teams"
    remove_foreign_key "team_results", "events"
    remove_foreign_key "team_results", "teams"
    remove_foreign_key "teams", "genders"
    remove_foreign_key "teams", "levels"
    remove_foreign_key "teams", "programs"
    remove_foreign_key "teams", "schedule_sources"
    remove_foreign_key "teams", "schools"
    remove_foreign_key "teams", "seasons"
    remove_foreign_key "teams", "sports"
    remove_foreign_key "teams", "years"

    change_column :events, :id, :string
    change_column :pressbox_posts, :event_id, :string
    change_column :results, :event_id, :string
    change_column :team_events, :event_id, :string
    change_column :team_results, :event_id, :string

    change_column :schools, :id, :string
    change_column :teams, :school_id, :string
    change_column :programs, :school_id, :string

    change_column :locations, :id, :string
    change_column :schools, :location_id, :string
    change_column :events, :location_id, :string

    change_column :programs, :id, :string
    change_column :teams, :program_id, :string

    change_column :pressbox_posts, :id, :string

    change_column :teams, :id, :string
    change_column :pressbox_posts, :team_id, :string
    change_column :team_events, :team_id, :string
    change_column :team_results, :team_id, :string

    add_foreign_key "device_subscriptions", "devices"
    add_foreign_key "events", "locations"
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
end
