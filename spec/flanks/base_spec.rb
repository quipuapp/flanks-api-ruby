require "spec_helper"

describe Flanks do
  before { configure_flanks }

  describe "#configuration" do
    it "returns a Configuration instance" do
      expect(subject.configuration).to be_a(Flanks::Configuration)
    end
  end

  describe "#configure" do
    it "returns the credentials properly" do
      expect(subject.configuration.client_id).to eq('a_client_id')
      expect(subject.configuration.client_secret).to eq('the_super_secret_stuff')
      expect(subject.configuration.username).to eq('an_email')
      expect(subject.configuration.password).to eq('le_password')
    end
  end

  describe "#api_call" do
    let(:path) { '/v0/some/endpoint' }
    let(:params) { { a: :b, c: :d, e: :f } }
    let(:api_call) {
      subject.api_call(method: method, path: path, params: params, token: token)
    }

    before do
      allow(RestClient::Request).to receive(:execute) { {} }
    end

    context "for a GET request" do
      let(:method) { :get }

      context "with a bearer token" do
        let(:token) { 'tok123456789' }

        it "works" do
          expect(subject)
            .to receive(:log_request)
            .with(
              :get,
              "https://api.flanks.io/v0/some/endpoint",
              {
                'Content-Type' => 'application/json',
                Authorization: 'Bearer tok123456789'
              },
              { a: :b, c: :d, e: :f }
            )

          expect(RestClient::Request)
            .to receive(:execute)
            .with(
              method: :get,
              url: "https://api.flanks.io/v0/some/endpoint",
              headers: {
                'Content-Type' => 'application/json',
                Authorization: 'Bearer tok123456789',
                params: { a: :b, c: :d, e: :f }
              }
            )

          api_call
        end
      end
    end

    context "for a POST request" do
      let(:method) { :post }

      context "with a bearer token" do
        let(:token) { 'tok123456789' }

        it "works" do
          expect(subject)
            .to receive(:log_request)
            .with(
              :post,
              "https://api.flanks.io/v0/some/endpoint",
              {
                'Content-Type' => 'application/json',
                Authorization: 'Bearer tok123456789'
              },
              { a: :b, c: :d, e: :f }
            )

          expect(RestClient::Request)
            .to receive(:execute)
            .with(
              method: :post,
              url: "https://api.flanks.io/v0/some/endpoint",
              headers: {
                'Content-Type' => 'application/json',
                Authorization: 'Bearer tok123456789'
              },
              payload: "{\"a\":\"b\",\"c\":\"d\",\"e\":\"f\"}"
            )

          api_call
        end
      end

      context "with client credentials" do
        let(:token) { nil }

        it "works" do
          expect(subject)
            .to receive(:log_request)
            .with(
              :post,
              "https://api.flanks.io/v0/some/endpoint",
              {
                'Content-Type' => 'application/json'
              },
              { a: :b, c: :d, e: :f }
            )

          expect(RestClient::Request)
            .to receive(:execute)
            .with(
              method: :post,
              url: "https://api.flanks.io/v0/some/endpoint",
              headers: {
                'Content-Type' => 'application/json'
              },
              payload: "{\"a\":\"b\",\"c\":\"d\",\"e\":\"f\"}"
            )

          api_call
        end
      end
    end
  end

  describe "#log_request" do
    let(:method) { :cuca }
    let(:url) { "https://some.where/over/the/rainbow" }
    let(:headers) {
      { Authorization: "Bearer 123142515", cuca: :monga, a: :b }
    }
    let(:log_request) {
      subject.log_request(method, url, headers, params)
    }

    context "without params" do
      let(:params) { {} }

      it "works" do
        [
          "",
          "=> CUCA https://some.where/over/the/rainbow",
          "* Headers",
          "Authorization: <masked>",
          "cuca: monga",
          "a: b",
          "* No params"
        ].each do |unique_message|
          expect(subject).to receive(:log_message).with(unique_message).once
        end

        log_request
      end
    end

    context "with some params" do
      let(:params) {
        {
          client_secret: "the_super_secret_stuff",
          password: 'mipassword',
          b: :c,
          credentials_token: 'eltokencito',
          code: 'ruby',
          d: :e
        }
      }

      it "works" do
        [
          "",
          "=> CUCA https://some.where/over/the/rainbow",
          "* Headers",
          "Authorization: <masked>",
          "cuca: monga",
          "a: b",
          "* Params",
          "client_secret: <masked>",
          "password: <masked>",
          "b: c",
          "credentials_token: <masked>",
          "code: <masked>",
          "d: e",
        ].each do |unique_message|
          expect(subject).to receive(:log_message).with(unique_message).once
        end

        log_request
      end
    end
  end

  describe "#log_message" do
    context "without a message" do
      it "does not call the logger" do
        expect(Logger).not_to receive(:new)

        subject.log_message(nil)
      end
    end

    context "with a non-empty message" do
      context "with a nil Flanks.configuration.logger" do
        before do
          allow(Flanks).to receive_message_chain(:configuration, :logger) {
            nil
          }
        end

        it "does not call the logger" do
          expect_any_instance_of(Logger).not_to receive(:info)

          subject.log_message("cucamonga")
        end
      end

      context "with a set-up logger" do
        before do
          logger = double(Logger)
          allow(logger).to receive(:info) { }

          allow(Flanks).to receive_message_chain(:configuration, :logger) {
            logger
          }
        end

        it "calls the logger properly" do
          expect(Flanks.configuration.logger).to receive(:info).with("cucamonga").once

          subject.log_message("cucamonga")
        end
      end
    end
  end
end
