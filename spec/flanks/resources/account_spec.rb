require "spec_helper"

describe Flanks::Account do
  before do
    configure_flanks
  end

  describe "#get" do
    before do
      stub_request(:get, "https://api.flanks.io/v0/bank/credentials/account?credentials_token=THE_TOKCREDENTIALS").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          }
        ).
        to_return(status: 200, body: response_json(resource: 'account', action: 'get'))
    end

    it "works" do
      account = Flanks::Account.get(
        token: 'THIS_IS_EL_BUEN_TOKEN',
        credentials_token: 'THE_TOKCREDENTIALS'
      )

      expect(account.class).to eq(Flanks::Account)
      expect(account.iban).to eq("ES4501822763517295596839")
      expect(account.entity).to eq("Banco Random")
      expect(account.alias).to eq("Cuenta Random de Ahorros")
      expect(account.balance).to eq(1034.19)
      expect(account.currency).to eq("EUR")
      expect(account.description).to eq("La boena descrepsión")
      expect(account.isOwner).to be_truthy
      expect(account.numOwners).to eq(3)
      expect(account.owners).to eq(
        [
          "Juanita admin", "Pepito colaborador", "Florencia gestora"
        ]
      )
      expect(account._id).to eq("abc12340a0011234fda")
    end
  end
end
