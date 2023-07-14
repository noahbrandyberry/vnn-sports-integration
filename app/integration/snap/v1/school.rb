module Snap
  module V1
    class School < Base
      @endpoint = 'schools'

      attr_accessor :school_id, :subdomain, :name, :address, :city, :state, :zip, :phone, :fax, :latitude, :longitude, :mascot, :motto, :url, :color1, :color2, :facebook_url, :twitter_url, :color_icon, :color_primary_text, :color_secondary_text, :color_slide_menu, :color_slide_menu_text, :color_theme, :ad_school, :enrollment, :pricing_tier, :kind, :vnn, :record

      def record_id
        "snap-#{school_id}"
      end

      def logo_url
        "https://8to18-logos.s3.amazonaws.com/images/#{state.downcase}-#{subdomain.downcase}.png"
      end

      def convert_to_record
        location = Location.new(
          id: record_id,
          name: name,
          address_1: address,
          city: city,
          state: state,
          zip: zip,
          latitude: latitude,
          longitude: longitude,
        )

        location.geocode

        location.timezone = Timezone.lookup(location.latitude, location.longitude).name

        record_class.new(
          id: record_id,
          name: name,
          mascot: mascot,
          is_vnn: vnn,
          url: url,
          primary_color: color1,
          secondary_color: color2,
          logo_url: logo_url,
          phone: phone,
          visible: true,
          location: location
        )
      end

      def destroy_record
        if existing_record
          existing_record.teams.map do |team|
            team.team_events.destroy_all
            team.images.destroy_all

            team.events.each do |event|
              event_location = event.location
              event.destroy
              event_location.destroy if event_location
            end

            team.destroy
          end
        end

        super

        location = Location.find_by(id: "snap-#{school_id}")
        location.destroy if location
      end

      def import
        super

        Snap::V1::Team.import_all(school_id: school_id, year: '2023-2024')
      end
    end
  end
end