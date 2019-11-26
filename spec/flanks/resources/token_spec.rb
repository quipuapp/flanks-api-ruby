require "spec_helper"

module Flanks
  describe Token do
    before do
      configure_flanks
    end

    describe "#create" do
      before do
        stub_request(:post, "https://api.flanks.io/v0/token").
          with(
            body: '{"client_id":"a_client_id","client_secret":"the_super_secret_stuff","username":"an_email","password":"le_password","grant_type":"password"}',
            headers: { 'Content-Type' => 'application/json' }
          ).
          to_return(status: 200, body: response_json(resource: 'token', action: 'create'))
      end

      it "works" do
        token = Flanks::Token.create

        expect(token.class).to eq(Flanks::Token)
        expect(token.access_token).to eq("aPscYAeKMbvLpWYgNYvtHUtsMOHxMT")
        expect(token.expires_in).to eq(36000)
        expect(token.token_type).to eq("Bearer")
        expect(token.scope).to eq("read write aggregation payment")
        expect(token.refresh_token).to eq("VwkqYDisjvIWNKJGjbFuOcyEacQchT")
      end
    end
  end
end
