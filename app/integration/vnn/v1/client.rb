module Vnn
  module V1
    module Client
      API_ENDPOINT = 'https://connect.vnnsports.net/'.freeze
      USERNAME = ENV["VNN_USERNAME"].freeze
      PASSWORD = ENV["VNN_PASSWORD"].freeze

      class << self
        def client
          Faraday.new(url: API_ENDPOINT) do |client|
            client.request :url_encoded
            client.adapter Faraday.default_adapter
            client.response :json
          end
        end

        def refresh_token
          login_response = request(
            http_method: 'post', 
            endpoint: 'authorize?client_id=Dashboard&response_type=code&redirect_uri=https://home.getvnn.com', 
            params: {login: USERNAME, password: PASSWORD}, 
          )

          code = URI::decode_www_form(URI.parse(login_response.headers['location']).query).to_h['code']

          oauth_response = request(
            http_method: 'post', 
            endpoint: 'oauth/token?client_id=Dashboard&response_type=code&redirect_uri=https://home.getvnn.com', 
            params: {client_id: 'Dashboard', code: code, redirect_uri: 'https://home.getvnn.com', grant_type: 'authorization_code'}, 
          )

          IntegrationToken.create(
            integration_name: 'vnn', 
            access_token: oauth_response.body['access_token'], 
            expires_in: oauth_response.body['expires_in'],
            token_type: oauth_response.body['access_token'],
            scope: oauth_response.body['scope']
          )

          oauth_response.body['access_token']
        end

        def authorized_request(http_method:, endpoint:, params: {})
          token = IntegrationToken.latest_valid_token 'vnn'
          unless token
            token = refresh_token
          end

          request(http_method: http_method, endpoint: endpoint, params: params, headers: {'Authorization': "Bearer #{token}"}).body
        end

        def request(http_method:, endpoint:, params: {}, headers: {})
          response = client.public_send(http_method, endpoint, params, headers)
        end
      end
    end
  end
end