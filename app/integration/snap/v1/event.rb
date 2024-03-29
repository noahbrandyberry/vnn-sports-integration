module Snap
  module V1
    class Event < Base
      @endpoint = 'events'

      attr_accessor :event_id, :event_date, :start_time, :end_time, :description, :season, :location, :place, :opponent, :kind, :team_id, :url, :short_name, :results, :cancellation_status, :conference, :school_id

      def record_id
        "snap-#{school_id}-#{team_id}-#{event_id}"
      end

      def convert_to_record
        school_location = Location.find_by(id: "snap-#{school_id}")
        home = place == 'H'

        location_search = home && school_location ? "#{location} #{school_location.city}" : location
        location_results = location.present? ? Geocoder.search(location_search, locationbias: "point:#{school_location.latitude},#{school_location.longitude}") : []
        location_results = location_results.select {|result| school_location.distance_to(result.coordinates) < 75}
        location_result = location_results.sort_by {|result| school_location.distance_to(result.coordinates)}.first

        timezone = Timezone['America/New_York']

        if location_result && location_result.place_id
          location_place = Geocoder.search(location_result.place_id, lookup: :google_places_details).first
          begin
            timezone = Timezone.lookup(location_place.latitude, location_place.longitude)
          rescue StandardError => e
            timezone = Timezone['America/New_York']
          end
          if location_place && location_place.street_address.present?
            new_location_record = Location.new(
              id: "snap-#{school_id}-#{team_id}-#{event_id}",
              name: location,
              address_1: location_place.street_address,
              city: location_place.city,
              state: location_place.state,
              zip: location_place.postal_code,
              latitude: location_place.latitude,
              longitude: location_place.longitude,
              timezone: timezone.name
            )
          end
        else
          unless location.present?
            new_location_record = Location.new(
              id: "snap-#{school_id}-#{team_id}-#{event_id}",
              name: school_location.name,
              address_1: school_location.address_1,
              address_2: school_location.address_2,
              city: school_location.city,
              state: school_location.state,
              zip: school_location.zip,
              latitude: school_location.latitude,
              longitude: school_location.longitude,
              timezone: timezone.name
            )
          end
        end

        begin
          start = DateTime.strptime("#{event_date} #{start_time} #{timezone.utc_offset / 60 / 60}", '%m/%d/%Y %l:%M %p %z')
        rescue ArgumentError => e
          tba = true
          begin
            start = DateTime.strptime("#{event_date} #{timezone.utc_offset / 60 / 60}", '%m/%d/%Y %z')
          rescue ArgumentError => e
          end
        end

        result = results.find { |r| r['score'].present? }

        has_result = result && result['score'].match(/^(\d)+$/) && result['opponent_score'].match(/^(\d)+$/)
        has_team_result = result && result['score'].include?('Place')
        has_post = result && result['story'].present?

        record_class.new(
          id: record_id,
          name: description || short_name.delete_prefix('vs ').delete_prefix('at '),
          event_type: kind.downcase,
          start: start,
          tba: tba,
          conference: conference,
          scrimmage: (description || '').include?('Scrimmage'),
          canceled: cancellation_status,
          location: new_location_record,
          location_name: location,
          team_events: [
            TeamEvent.new(team_id: "snap-#{school_id}-#{team_id}", home: home, opponent_name: opponent, public_notes: description)
          ],
          result: has_result ? Result.new(home: result[home ? 'score' : 'opponent_score'], away: result[home ? 'opponent_score' : 'score']) : nil,
          team_results: has_team_result ? [
            TeamResult.new(team_id: "snap-#{school_id}-#{team_id}", place: result['score'].gsub(/\D/, ''))
          ] : [],
          pressbox_posts: has_post ? [
            PressboxPost.new(
              id: record_id,
              team_id: "snap-#{school_id}-#{team_id}",
              title: description || short_name.delete_prefix('vs ').delete_prefix('at '),
              recap: {Summary: result['story']}.to_json,
              created: start,
              is_visible: true
            )
          ] : []
        )
      end

      def destroy_record
        if existing_record
          existing_record.pressbox_posts.destroy_all
          existing_record.team_events.destroy_all
          existing_record.team_results.destroy_all
          existing_record.result.try(:destroy)
          event_location = existing_record.location
          super
          event_location.destroy if event_location
        end
      end
    end
  end
end