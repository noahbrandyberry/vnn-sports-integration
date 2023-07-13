module Snap
  module V1
    class Base
      def initialize params = {}
        params.each do |key, value|
          public_send("#{key}=",value)
        end
      end

      def import
        new_record = convert_to_record
        return unless new_record.valid?

        destroy_record

        new_record.save
      end

      def destroy_record
        record = existing_record
        record.destroy if record
      end

      def existing_record
        record_class.find_by(id: record_id)
      end

      def record_class
        self.class.record_class
      end

      def self.record_class
        Object.const_get(self.name.demodulize)
      end

      def self.all **params
        Client.request(
          http_method: :get,
          endpoint: @endpoint,
          params: {limit: 1000}.merge(params)
        )['objects'].map do |school|
          self.new **school, **params
        end
      end

      def self.find id
        self.new Client.request(
          http_method: :get,
          endpoint: "#{@endpoint}/#{id}",
        )
      end
      
      def self.import_all **params
        all(**params).each do |record|
          record.import
        end
      end
    end
  end
end