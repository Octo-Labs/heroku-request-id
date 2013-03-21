# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku/request/id/version'

Gem::Specification.new do |spec|
  spec.name          = "heroku-request-id"
  spec.version       = Heroku::Request::Id::VERSION
  spec.authors       = ["Jeremy Green"]
  spec.email         = ["jeremy@octolabs.com"]
  spec.description   = %q{Simple Rack middleware to log the heroku request id and write it to the end of html requests. Both optionally, of course.}
  spec.summary       = %q{Simple Rack middleware to log the heroku request id and write it to the end of html requests. Both optionally, of course.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
end
