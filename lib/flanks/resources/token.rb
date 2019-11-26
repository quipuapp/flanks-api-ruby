module Flanks
  class Token < Resource
    RESOURCE_PATH = '/v0/token'

    has_fields :access_token, :expires_in, :token_type, :scope, :refresh_token

    def self.create
      response = Flanks.api_call(
        method: :post,
        path: RESOURCE_PATH,
        params: {
          client_id: Flanks.configuration.client_id,
          client_secret: Flanks.configuration.client_secret,
          username: Flanks.configuration.username,
          password: Flanks.configuration.password,
          grant_type: 'password'
        }
      )
      new(response)
    end
  end
end
