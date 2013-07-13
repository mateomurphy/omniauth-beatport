$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'webmock/rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth-beatport'

OmniAuth.config.logger = Logger.new(false)

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end
