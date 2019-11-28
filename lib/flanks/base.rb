require 'rest-client'
require 'json'

module Flanks
  BASE_URL = 'https://api.flanks.io'
  SENSIBLE_HEADERS = %w{Authorization}
  SENSIBLE_PARAMS = %w{client_secret password credentials_token code}

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

      headers = { 'Content-Type' => 'application/json' }

      if method == :post
        payload = params.to_json
      else
        headers.merge!(params: params)
      end

      unless token.nil?
        headers.merge!(Authorization: "Bearer #{token}")
      end

      log_request(method, url, headers, params)

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

    def log_request(method, url, headers, params)
      log_message("")
      log_message("=> #{method.upcase} #{url}")

      log_message("* Headers")
      headers.each do |key, value|
        next if key == :params

        safe_value = if SENSIBLE_HEADERS.include?(key.to_s)
                       "<masked>"
                     else
                       value
                     end

        log_message("#{key}: #{safe_value}")
      end

      if params.any?
        log_message("* Params")
        params.each do |key, value|
          safe_value = if SENSIBLE_PARAMS.include?(key.to_s)
                         "<masked>"
                       else
                         value
                       end

          log_message("#{key}: #{safe_value}")
        end
      else
        log_message("* No params")
      end
    end

    def log_message(message)
      return if message.nil?

      logger = Flanks.configuration.logger
      return if logger.nil?

      logger.info(message)
    end
  end
end
