$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'webmock/rspec'
require "flanks"

def response_json(resource:, action:)
  path = File.join('spec', 'responses', resource, "#{action}.json")
  File.read(path)
end

def configure_flanks
  Flanks.configure do |config|
    config.client_id = 'a_client_id'
    config.client_secret = 'the_super_secret_stuff'
    config.username = 'an_email'
    config.password = 'le_password'
  end
end
