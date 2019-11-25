# frozen_string_literal: true

module Api::V1
  class Api::V1::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    def redirect_callbacks
      # derive target redirect route from 'resource_class' param, which was set
      # before authentication.
      devise_mapping = [request.env["omniauth.params"]["namespace_name"],
                        request.env["omniauth.params"]["resource_class"].underscore.gsub("/", "_")].compact.join("_")
      path = "#{Devise.mappings[devise_mapping.to_sym].fullpath}/#{params[:provider]}/callback"
      klass = request.scheme == "https" ? URI::HTTPS : URI::HTTP

      redirect_route = klass.build(host: request.host, port: request.port, path: path).to_s

      # preserve omniauth info for success route. ignore 'extra' in twitter
      # auth response to avoid CookieOverflow.
      session["dta.omniauth.auth"] = request.env["omniauth.auth"].except("extra")
      session["dta.omniauth.params"] = request.env["omniauth.params"]

      redirect_to redirect_route + "?origin=" + request.env["omniauth.params"]["redirect_uri"]
    end

    def omniauth_success
      get_resource_from_auth_hash
      #  look for existing email already
      user = User.find_by(email: auth_hash["info"]["email"])
      if user
        @resource = user

      else
        Rails.logger.error auth_hash.inspect
        @resource.nickname = auth_hash["info"]["name"].parameterize
        @resource.email = auth_hash["info"]["email"]
        @resource.name = auth_hash["info"]["name"]
        @resource.location_id = 1
      end
      set_token_on_resource
      create_auth_params

      if confirmable_enabled?
        # don't send confirmation email!!!
        @resource.skip_confirmation!
      end
      
      sign_in(:user, @resource, store: false, bypass: false)

      if @resource.save
        Rails.logger.error 'saved'
        yield @resource if block_given?
        Rails.logger.error Rails.application.credentials.redirects[:terminal]
        Rails.logger.error DeviseTokenAuth::Url.generate(Rails.application.credentials.redirects[:terminal], @auth_params.as_json.merge(user_id: @resource.id))
        # auth_origin_url = ENV['frontend_url']
        # logger.warn 'aou is ' + auth_origin_url
        # render_data_or_redirect('deliverCredentials', @auth_params.as_json, @resource.as_json)
        redirect_to DeviseTokenAuth::Url.generate(Rails.application.credentials.redirects[:terminal], @auth_params.as_json.merge(user_id: @resource.id))
      else
        render json: { "status" => "error", "message" => @resource.errors.full_messages }.to_json
        # respond_with_errors(@resource) and return
      end
    end

    def omniauth_failure
      super
    end
  end
end
