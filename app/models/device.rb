class Device < ApplicationRecord
  has_many :device_subscriptions, dependent: :destroy
  accepts_nested_attributes_for :device_subscriptions, allow_destroy: true

  def self.send_push_notifications
    all.includes(device_subscriptions: [:subscribable]).each do |device|
      device.teams.each do |team|
        offset_time = Time.now.ago(30.minutes)
        events = team.events.where(start: offset_time.beginning_of_hour..offset_time.end_of_hour)

        events.each do |event|
          n = Rpush::Apnsp8::Notification.new
          n.app = Rpush::Apnsp8::App.find_by_name("ios_app")
          n.device_token = device.device_token
          n.alert = "#{team.name} - #{event.name} is starting at #{event.start.in_time_zone(event.location.timezone).strftime("%l:%M%P")}"
          n.data = { school_id: team.school_id || team.program.school_id, team_id: team.id, event_id: event.id }
          n.save!
        end
      end
    end
  end

  def teams
    device_subscriptions.map { |subscription| subscription.subscribable_type == 'School' ? subscription.subscribable.all_teams : subscription.subscribable }.flatten.uniq
  end
end
