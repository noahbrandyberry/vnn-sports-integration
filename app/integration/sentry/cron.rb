module Sentry
  class Cron
    def initialize base_url
      @client = Faraday.new(url: base_url) do |client|
        client.adapter Faraday.default_adapter
      end
    end

    def request status
      @client.get('', {status: status}).body
    end

    def start
      request 'in_progress'
    end

    def complete
      request 'ok'
    end

    def error
      request 'error'
    end
  end
end