require 'spec_helper'


describe OmniAuth::Strategies::Beatport do
  let :access_token_body do
    'oauth_token=token&oauth_token_secret=secret'
  end
  
  let :request_token_body do
    'oauth_token=token&oauth_token_secret=secret&oauth_callback_confirmed=true'
  end
  
  let :identity_body do
    '{"id":101,"username":"username","first_name":"first_name","last_name":"last_name","email_confirmed":true,"register_email_address":"email@example.com","register_ip_address":"127.0.0.1","created":"2007-10-24 23:37:23","paypal_email_address":"paypal_email@example.com","betaFeatures":[{"id":5,"name":"mixes","slug":"mixes"}]}'
  end
  
  def app
    Rack::Builder.new {
      use OmniAuth::Test::PhonySession
      use OmniAuth::Builder do
        provider :beatport, 'api_key', 'api_secret'
      end
      run lambda { |env| [404, {'Content-Type' => 'text/plain'}, [env.key?('omniauth.auth').to_s]] }
    }.to_app
  end

  def session
    last_request.env['rack.session']
  end

  before do
    stub_request(:post, 'https://oauth-api.beatport.com/identity/1/oauth/request-token').to_return(:body => request_token_body)
    stub_request(:post, 'https://oauth-api.beatport.com/identity/1/oauth/access-token').to_return(:body => access_token_body)
    stub_request(:get, 'https://oauth-api.beatport.com/identity/1/person').to_return(:status => 200, :body => identity_body, :headers => {})
  end  
  
  describe '/auth/beatport' do
    before do
      get '/auth/beatport'
    end

    it 'redirects' do
      last_response.should be_redirect
    end

    it 'redirects to authorize_url' do
      last_response.headers['Location'].should == 'https://oauth-api.beatport.com/identity/1/oauth/authorize?oauth_token=token'
    end

    it 'sets appropriate session variables' do
      session['oauth'].should == {"beatport"=>{"callback_confirmed"=>true, "request_token"=>"token", "request_secret"=>"secret"}}
    end
  end  
  
  describe '/auth/beatport/callback' do
    before do
      get '/auth/beatport/callback', {:oauth_verifier => '33degrees'}, {'rack.session' => {'oauth' => {"beatport" => {'callback_confirmed' => true, 'request_token' => 'token', 'request_secret' => 'secret'}}}}
    end

    it 'set the provider' do
      last_request.env['omniauth.auth']['provider'].should == 'beatport'
    end
    
    it 'exchanges the request token for an access token' do
      last_request.env['omniauth.auth']['extra']['access_token'].should be_kind_of(OAuth::AccessToken)
    end

    it 'sets the uid' do
      last_request.env['omniauth.auth']['uid'].should eq(101)
    end

    it 'sets the nickname' do
      last_request.env['omniauth.auth']['info']['nickname'].should eq('username')
    end

    it 'calls through to the master app' do
      last_response.body.should == 'true'
    end
  end
  
end