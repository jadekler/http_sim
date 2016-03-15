# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scaffold/version'

Gem::Specification.new do |spec|
  spec.name          = 'scaffold'
  spec.version       = Scaffold::VERSION
  spec.authors       = ['Jean de Klerk']
  spec.email         = ['jadekler@gmail.com']
  spec.summary       = 'Simulate your external HTTP integrations.'
  spec.description   = 'A set of utilities for creating simulators for your external HTTP integrations, great for acceptance tests and fallback services.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'sinatra', '~> 1.4.0'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end
