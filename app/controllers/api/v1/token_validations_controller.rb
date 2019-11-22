# frozen_string_literal: true

module Api::V1
  class TokenValidationsController < DeviseTokenAuth::TokenValidationsController
    include DeviseFixes

    def validate_token
      super
    end

    protected

    def render_validate_token_success
      render json: UserSerializer.new(@resource, {include: [:location]}).serialized_json, status: 200      
    end

  end
end