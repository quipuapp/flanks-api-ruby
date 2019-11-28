require "spec_helper"

describe Flanks::Link do
  before do
    configure_flanks
  end

  describe "#create" do
    before do
      stub_request(:post, "https://api.flanks.io/v0/platform/link").
        with(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => 'Bearer THIS_IS_EL_BUEN_TOKEN'
          },
          body: "{\"code\":\"EL_LINK_CODIO\"}"
        ).
        to_return(status: 200, body: response_json(resource: 'link', action: 'create'))
    end

    it "works" do
      link = Flanks::Link.create(token: 'THIS_IS_EL_BUEN_TOKEN', code: 'EL_LINK_CODIO')

      expect(link.class).to eq(Flanks::Link)
      expect(link.message).to eq("Successfully retrieved")
      expect(link.credentials_token).to eq("THE_CREDENTIALS_TOKEN_FOR_YOU")
      expect(link.extra.class).to eq(Hash)
      expect(link.extra.keys).to eq(%w{a_key b_key})
      expect(link.extra['a_key']).to eq("a_content")
      expect(link.extra['b_key']).to eq("b_content")
    end
  end
end
