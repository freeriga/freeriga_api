Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.credentials.facebook[:client_id], Rails.application.credentials.facebook[:secret], callback_url: Rails.env.development? ? 'http://localhost:3000/omniauth/facebook/callback' :  'https://api.freeriga.lv/omniauth/facebook/callback'
end