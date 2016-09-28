# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnip-rules/version'

Gem::Specification.new do |spec|
  spec.name          = "gnip-rules"
  spec.version       = Gnip::VERSION
  spec.authors       = ["Spencer Markowski", "The Able Few"]
  spec.email         = ["spencer@theablefew.com"]
  spec.description   = "Remove, Add and List your Gnip Rules"
  spec.summary       = "A simple wrapper for the Gnip Rules API"

  spec.homepage      = "http://github.com/theablefew/gnip-rules"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"

  spec.add_dependency('httparty', '>= 0')
  spec.add_dependency('json', '>= 1.5.1')
  spec.add_dependency('activesupport', '>= 3.1.3')
end

