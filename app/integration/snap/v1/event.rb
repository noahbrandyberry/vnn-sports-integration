module Snap
  module V1
    class Event < Base
      @endpoint = 'events'

      attr_accessor :event_id, :event_date, :start_time, :end_time, :description, :season, :location, :place, :opponent, :kind, :team_id, :url, :short_name, :results, :cancellation_status, :conference, :school_id

      def record_id
        "snap-#{school_id}-#{team_id}-#{event_id}"
      end

      def convert_to_record
        start = DateTime.strptime("#{event_date} #{start_time}", '%m/%d/%Y %l:%M %p')

        record_class.new(
          id: record_id,
          name: short_name,
          event_type: kind.downcase,
          start: start,
          conference: conference,
          scrimmage: (description || '').include?('Scrimmage'),
          canceled: cancellation_status,
          team_events: [
            TeamEvent.new(team_id: "snap-#{school_id}-#{team_id}", home: place == 'H', opponent_name: opponent, public_notes: description)
          ]
        )
      end
    end
  end
end