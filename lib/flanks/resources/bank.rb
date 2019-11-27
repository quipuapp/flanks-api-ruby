module Flanks
  class Bank < Resource
    RESOURCE_PATH = '/v0/bank/available'

    has_fields :id, :name

    def self.list(token:)
      response = Flanks.api_call(
        method: :get,
        path: RESOURCE_PATH,
        token: token
      )
      Collection.new(response, self)
    end
  end
end
