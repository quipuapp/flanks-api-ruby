require "spec_helper"

describe Flanks::Bank do
  before do
    configure_flanks
  end

  describe "#list" do
    before do
      stub_request(:get, "https://api.flanks.io/v0/bank/available").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          }
        ).
        to_return(status: 200, body: response_json(resource: 'bank', action: 'list'))
    end

    it "works" do
      banks = Flanks::Bank.list(token: 'THIS_IS_EL_BUEN_TOKEN')

      expect(banks.class).to eq(Flanks::Collection)
      expect(banks.size).to eq(3)

      bank1, bank2, bank3 = banks

      expect(bank1.class).to eq(Flanks::Bank)
      expect(bank1.id).to eq("12")
      expect(bank1.name).to eq("Banc 1")

      expect(bank2.class).to eq(Flanks::Bank)
      expect(bank2.id).to eq("13")
      expect(bank2.name).to eq("Banc 2")

      expect(bank3.class).to eq(Flanks::Bank)
      expect(bank3.id).to eq("14")
      expect(bank3.name).to eq("Banc 3")
    end
  end
end
