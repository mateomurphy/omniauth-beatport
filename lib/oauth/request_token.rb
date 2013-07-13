module OAuth
  class RequestToken < ConsumerToken
    def callback_confirmed?
      params[:oauth_callback_confirmed] == "true" || params[:oauth_callback_confirmed] == "1"
    end    
  end
end