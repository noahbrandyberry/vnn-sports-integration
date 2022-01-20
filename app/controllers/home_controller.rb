# require 'faraday'
# require 'faraday_middleware'

class HomeController < ApplicationController
  def index
    url = 'https://connect.vnnsports.net/school/2136/teams?current_year=true&valid=true'

    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    @teams = conn.get.body['_embedded']['team']
  end
end
