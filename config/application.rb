require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
# require_relative "../app/middleware/selective_stack"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Freeriga
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.swagger_dry_run = false
    config.time_zone = 'UTC'
    config.active_record.default_timezone = :utc
    config.i18n.default_locale = :lv
    config.i18n.fallbacks = [I18n.default_locale, {
      lv: [:lv, :en, :ru],
      ru: [:ru, :lv, :en],
      en: [:en, :lv, :ru]
    }]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.session_store :cookie_store, key: "_freeriga_session"
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*",
          headers: :any,
          methods: %i[get post options delete put],
          expose: ['access-token', 'auth_token', 'client_id', 'expiry', 'token-type', 'uid', 'client']
      end
    end  

    config.middleware.delete Rack::ETag
  end
end

RSpec.configure do |config|
  config.swagger_dry_run = false
end
