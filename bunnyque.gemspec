# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunnyque/version'

Gem::Specification.new do |spec|
  spec.name          = "bunnyque"
  spec.version       = Bunnyque::VERSION
  spec.authors       = ["Wouter de Vos"]
  spec.email         = ["wouter@springest.com"]
  spec.summary       = %q{Jobs in RabbitMQ}
  spec.description   = %q{Jobs in RabbitMQ that support fanout.}
  spec.homepage      = "https://github.com/foxycoder/bunnyque"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
