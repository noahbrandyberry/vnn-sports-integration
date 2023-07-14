module Snap
  module V1
    class Image < Base
      @endpoint = 'images'

      attr_accessor :image_id, :school_id, :sport_gender_level, :title, :url, :created_at, :team_id

      def record_id
        "snap-#{school_id}-#{image_id}"
      end

      def convert_to_record
        record_class.new(
          id: record_id,
          description: title,
          url: url,
          team_id: "snap-#{school_id}-#{team_id}"
        )
      end
    end
  end
end