class SelectiveStack
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"].start_with?("/api/") # <--- Change URL path here
      @app.call(env)
    else
      middleware_stack.build(@app).call(env)
    end
  end

private
  def middleware_stack
    @middleware_stack ||= begin
      ActionDispatch::MiddlewareStack.new.tap do |middleware|
        # needed for OmniAuth
        middleware.use ActionDispatch::Cookies
        middleware.use Rails.application.config.session_store, Rails.application.config.session_options
        middleware.use OmniAuth::Builder #, &OmniAuthConfig
        # needed for Doorkeeper /oauth views
        middleware.use ActionDispatch::Flash
      end
    end
  end
end