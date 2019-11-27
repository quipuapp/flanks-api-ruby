require "spec_helper"

describe Flanks do
  describe "#configuration" do
    # TODO
  end

  describe "#configure" do
    # TODO
  end

  describe "#api_call" do
    # TODO
  end

  describe "#log_request" do
    # TODO
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
          expect(Flanks.configuration.logger).not_to receive(:info)

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
