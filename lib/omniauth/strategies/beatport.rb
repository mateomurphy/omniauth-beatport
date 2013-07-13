require 'omniauth-oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    class Beatport < OmniAuth::Strategies::OAuth
      
      option :name, 'beatport'
      
      option :client_options, {
        :access_token_path => "/identity/1/oauth/access-token",
        :authorize_path => "/identity/1/oauth/authorize",
        :request_token_path => "/identity/1/oauth/request-token",
        :site => "https://oauth-api.beatport.com"
      }
      
      uid { 
        raw_info['id']
      }
      
      info do 
        raw_info.to_hash
      end
      
      extra do
        {
          :raw_info => raw_info
        }
      end
     
      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('/identity/1/person').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end