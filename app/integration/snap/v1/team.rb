module Snap
  module V1
    class Team < Base
      @endpoint = 'teams'

      attr_accessor :team_id, :year, :sport, :gender, :level, :sport_gender_level, :roster, :school_id

      def initialize params = {}
        super

        if @sport.ends_with?(' MS')
          @sport = @sport.delete_suffix(' MS')
          @level = 'MS'
        end

        if @sport.starts_with?('Youth ')
          @sport = @sport.delete_prefix('Youth ')
          @level = 'Youth'
        end
      end

      def record_id
        "snap-#{school_id}-#{team_id}"
      end

      def convert_to_record
        seasons = Season.all

        gender_record = Gender.find_by('name LIKE ?', "#{gender}%")
        level_record = Level.find_by('name LIKE ?', "#{level.chars.first}%")
        sport_record = Sport.find_by(name: sport) || Sport.create(id: Time.now.to_f.to_s.gsub(".", ""), name: sport)
        name = [gender_record, level_record, sport_record].compact.join(' ')

        year_record = Year.find_by(name: year.gsub('-', '/'))
        season_record = seasons.select { |season| sport.include?(season.name) }.first || Sport.find_by(name: sport.split.first).try(:season) || sport_record.season || Season.find_by(name: 'Year-round')

        record_class.new(
          id: record_id,
          name: name,
          year: year_record,
          season: season_record,
          level: level_record,
          school_id: "snap-#{school_id}",
          gender: gender_record,
          sport: sport_record
        )
      end

      def destroy_record
        if existing_record
          existing_record.pressbox_posts.destroy_all
          existing_record.team_events.destroy_all
          existing_record.team_results.destroy_all
          existing_record.images.destroy_all

          existing_record.events.each do |event|
            event.team_results.destroy_all
            event.result.try(:destroy)
            event_location = event.location
            event.destroy
            event_location.destroy if event_location
          end
        end

        super
      end

      def import
        super

        Snap::V1::Event.import_all(school_id: school_id, team_id: team_id)
        Snap::V1::Image.import_all(school_id: school_id, sport_gender_level: sport_gender_level, team_id: team_id)
      end
    end
  end
end