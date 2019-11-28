require "spec_helper"

describe Flanks::Account do
  before { configure_flanks }

  describe "#list" do
    before do
      stub_request(:post, "https://api.flanks.io/v0/bank/credentials/account").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          },
          body: "{\"credentials_token\":\"THE_TOKCREDENTIALS\"}"
        ).
        to_return(status: 200, body: response_json(resource: 'account', action: 'list'))
    end

    it "works" do
      accounts = Flanks::Account.list(
        token: 'THIS_IS_EL_BUEN_TOKEN',
        credentials_token: 'THE_TOKCREDENTIALS'
      )

      expect(accounts.class).to eq(Flanks::Collection)
      expect(accounts.size).to eq(2)

      account1, account2 = accounts

      expect(account1.class).to eq(Flanks::Account)
      expect(account1.iban).to eq("ES4501822763517295596839")
      expect(account1.entity).to eq("whatthebank")
      expect(account1.alias).to eq("Cuenta Random de Ahorros")
      expect(account1.balance).to eq(1034.19)
      expect(account1.currency).to eq("EUR")
      expect(account1.description).to eq("La boena descrepsión")
      expect(account1.isOwner).to be_truthy
      expect(account1.numOwners).to eq(3)
      expect(account1.owners).to eq(
        ["Juanita admin", "Pepito colaborador", "Florencia gestora"]
      )
      expect(account1._id).to eq("abc12340a0011234fda")

      expect(account2.class).to eq(Flanks::Account)
      expect(account2.iban).to eq("ES8620956428346945419764")
      expect(account2.entity).to eq("whatthebank")
      expect(account2.alias).to eq("Cuenta Random de Inversiones")
      expect(account2.balance).to eq(180_291.55)
      expect(account2.currency).to eq("EUR")
      expect(account2.description).to eq("Long term money")
      expect(account2.isOwner).to be_truthy
      expect(account2.numOwners).to eq(1)
      expect(account2.owners).to eq(
        ["Juanita admin"]
      )
      expect(account2._id).to eq("def78940a0011234fda")
    end
  end
end
