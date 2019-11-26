require 'rest-client'
require 'json'

module Flanks
  BASE_URL = 'https://api.flanks.io'

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def api_call(method:, path:, params: {}, token: nil)
      url = Flanks.const_get(:BASE_URL) + path

      headers = if token.nil?
                  { 'Content-Type' => 'application/json' }
                else
                  # TODO
                end

      if method == :post
        payload = params.to_json
      else
        headers.merge!(params: params)
      end

      request_params = {
        method: method,
        url: url,
        headers: headers,
        payload: payload
      }

      begin
        response = RestClient::Request.execute(request_params)
        return {} if response.empty?

        JSON.parse(response)
      rescue StandardError => error
        # TODO handle properly
        response = JSON.parse(error.response)
        raise Error.new(response['error'])
      end
    end
  end
end
