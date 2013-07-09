# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'omniauth-beatport/version'

Gem::Specification.new do |s|
  s.name          = "omniauth-beatport"
  s.version       = Omniauth::Beatport::VERSION
  s.authors       = ["Mateo Murphy"]
  s.email         = ["mateo.murphy@gmail.com"]
  s.homepage      = "https://github.com/mateomurphy/omniauth-beatport"
  s.summary       = "OmniAuth strategy for Beatport"
  s.description   = "OmniAuth strategy for Beatport"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  
  
end
