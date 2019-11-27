module Flanks
  class Account < Resource
    RESOURCE_PATH = '/v0/bank/credentials/account'

    has_fields :iban, :entity, :alias, :balance, :currency, :description,
               :isOwner, :numOwners, :owners, :_id

    def self.get(token:, credentials_token:)
      response = Flanks.api_call(
        method: :post,
        path: RESOURCE_PATH,
        token: token,
        params: {
          credentials_token: credentials_token
        }
      )
      new(response)
    end
  end
end
