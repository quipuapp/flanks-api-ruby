$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'webmock/rspec'
require "flanks"

def response_json(filename)
  path = File.join('spec', 'responses', "#{filename}.json")
  File.read(path)
end

def configure_bankin
  Flanks.configure do |config|
    # TODO
  end
end
