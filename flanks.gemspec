# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flanks/version'

Gem::Specification.new do |spec|
  spec.name          = "flanks-api-ruby"
  spec.version       = Flanks::VERSION
  spec.authors       = ["Albert Bellonch"]
  spec.email         = ["albert@getquipu.com"]

  spec.summary       = "Ruby client for the Flanks' API"
  spec.homepage      = "https://getquipu.com"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.0.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
