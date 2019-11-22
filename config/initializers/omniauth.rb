Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.credentials.facebook[:client_id], Rails.application.credentials.facebook[:secret]
end