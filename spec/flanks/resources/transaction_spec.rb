require "spec_helper"

describe Flanks::Bank do
  before do
    configure_flanks
  end

  describe "#list" do
    before do
      stub_request(:post, "https://api.flanks.io/v0/bank/credentials/data").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          },
          body: "{\"credentials_token\":\"THE_TOKCREDENTIALS\",\"query\":{\"account_id\":[\"A91515\"]}}"
        ).
        to_return(status: 200, body: response_json(resource: 'transaction', action: 'list'))
    end

    it "works" do
      transactions = Flanks::Transaction.list(
        token: 'THIS_IS_EL_BUEN_TOKEN',
        credentials_token: 'THE_TOKCREDENTIALS',
        account_id: 'A91515'
      )

      expect(transactions.class).to eq(Flanks::Collection)
      expect(transactions.size).to eq(3)

      transaction1, transaction2, transaction3 = transactions

      expect(transaction1.class).to eq(Flanks::Transaction)
      expect(transaction1._id).to eq("T1230045")
      expect(transaction1.account_id).to eq("A91515")
      expect(transaction1.amount).to eq(-12.34)
      expect(transaction1.balance).to eq(913.33)
      expect(transaction1.entity).to eq("whatthebank")
      expect(transaction1.cardNumber).to eq("abc")
      expect(transaction1.category).to eq("Sport")
      expect(transaction1.currency).to eq("EUR")
      expect(transaction1.operationDate).to eq("2019-10-11")
      expect(transaction1.valueDate).to eq("2019-10-12")
      expect(transaction1.description).to eq("A description")
      expect(transaction1.productDescription).to eq("A product description")
      expect(transaction1.transfer).to eq({
        "beneficiary" => "John Benefits",
        "ibanBeneficiary" => "ES5700752532614289557739",
        "ibanPayer" => "ES5904877762281252243113",
        "payer" => "Max Payer",
      })

      expect(transaction2.class).to eq(Flanks::Transaction)
      expect(transaction2._id).to eq("T1230046")
      expect(transaction2.account_id).to eq("A91515")
      expect(transaction2.amount).to eq(3.11)
      expect(transaction2.balance).to eq(916.44)
      expect(transaction2.entity).to eq("whatthebank")
      expect(transaction2.cardNumber).to eq("def")
      expect(transaction2.category).to eq("Leisure")
      expect(transaction2.currency).to eq("EUR")
      expect(transaction2.operationDate).to eq("2019-10-13")
      expect(transaction2.valueDate).to eq("2019-10-14")
      expect(transaction2.description).to eq("Another description")
      expect(transaction2.productDescription).to eq("Another product description")
      expect(transaction2.transfer).to eq({
        "beneficiary" => "Max Payer",
        "ibanBeneficiary" => "ES5904877762281252243113",
        "ibanPayer" => "ES2731905381475958758479",
        "payer" => "The Dude",
      })

      expect(transaction3.class).to eq(Flanks::Transaction)
      expect(transaction3._id).to eq("T1230047")
      expect(transaction3.account_id).to eq("A91515")
      expect(transaction3.amount).to eq(4.99)
      expect(transaction3.balance).to eq(921.43)
      expect(transaction3.entity).to eq("whatthebank")
      expect(transaction3.cardNumber).to eq("ghi")
      expect(transaction3.category).to eq("Finance")
      expect(transaction3.currency).to eq("EUR")
      expect(transaction3.operationDate).to eq("2019-10-15")
      expect(transaction3.valueDate).to eq("2019-10-16")
      expect(transaction3.description).to eq("The final description")
      expect(transaction3.productDescription).to eq("The final product description")
      expect(transaction3.transfer).to eq({
        "beneficiary" => "Max Payer",
        "ibanBeneficiary" => "ES5904877762281252243113",
        "ibanPayer" => "ES6801287657415495297851",
        "payer" => "Random Guy",
      })
    end
  end
end
