require "spec_helper"

describe Flanks::LinkCode do
  before do
    configure_flanks
  end

  describe "#pending" do
    before do
      stub_request(:get, "https://api.flanks.io/v0/platform/link?client_id=a_client_id").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          }
        ).
        to_return(status: 200, body: response_json(resource: 'link_code', action: 'pending'))
    end

    it "works" do
      link_codes = Flanks::LinkCode.pending(token: 'THIS_IS_EL_BUEN_TOKEN')

      expect(link_codes.class).to eq(Flanks::Collection)
      expect(link_codes.size).to eq(3)
      expect(link_codes[0].class).to eq(Flanks::LinkCode)
      expect(link_codes[0].code).to eq("a_first_codego")
      expect(link_codes[1].class).to eq(Flanks::LinkCode)
      expect(link_codes[1].code).to eq("el_codi_numbru_2")
      expect(link_codes[2].class).to eq(Flanks::LinkCode)
      expect(link_codes[2].code).to eq("cuca_code_3")
    end
  end
end
