module Snap
  module V1
    module Client
      API_ENDPOINT = 'https://api-prod.8to18.com/v1/'.freeze
      OAUTH_TOKEN = ENV["SNAP_ACCESS_TOKEN"].freeze

      class << self
        def client
          @_client ||= Faraday.new(url: API_ENDPOINT) do |client|
            client.request :url_encoded
            client.adapter Faraday.default_adapter
            client.response :json
            client.headers['Authorization'] = "Token token=#{OAUTH_TOKEN}" if OAUTH_TOKEN.present?
          end
        end

        def request(http_method:, endpoint:, params: {})
          response = client.public_send(http_method, endpoint, params).body
        end
      end
    end
  end
end