module Flanks
  class LinkCode < Resource
    RESOURCE_PATH = '/v0/platform/link'

    has_fields :code

    def self.pending(token:)
      response = Flanks.api_call(
        method: :get,
        path: RESOURCE_PATH,
        token: token,
        params: {
          client_id: Flanks.configuration.client_id
        }
      )
      Collection.new(response, self)
    end
  end
end
