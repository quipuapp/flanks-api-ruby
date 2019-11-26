require "spec_helper"

module Flanks
  describe "Flanks::VERSION" do
    it "is the proper one" do
      expect(Flanks::VERSION).to eq("0.1.0")
    end
  end
end
