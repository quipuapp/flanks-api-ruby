module Flanks
  class Link < Resource
    RESOURCE_PATH = '/v0/platform/link'

    has_fields :message, :credentials_token, :extra

    def self.create(token:, code:)
      response = Flanks.api_call(
        method: :post,
        path: RESOURCE_PATH,
        token: token,
        params: {
          code: code
        }
      )
      new(response)
    end
  end
end
