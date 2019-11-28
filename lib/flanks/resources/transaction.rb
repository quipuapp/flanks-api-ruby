module Flanks
  class Transaction < Resource
    RESOURCE_PATH = '/v0/bank/credentials/data'

    has_fields :_id, :account_id, :amount, :balance, :entity, :cardNumber,
               :category, :currency, :operationDate, :valueDate,
               :description, :productDescription, :transfer

    def self.list(token:, credentials_token:, account_id:)
      response = Flanks.api_call(
        method: :post,
        path: RESOURCE_PATH,
        token: token,
        params: {
          credentials_token: credentials_token,
          query: {
            "account_id" => [account_id]
          }
        }
      )
      Collection.new(response, self)
    end
  end
end
