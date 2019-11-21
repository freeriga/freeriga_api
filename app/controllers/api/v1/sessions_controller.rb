# frozen_string_literal: true

module Api::V1
  class SessionsController < DeviseTokenAuth::SessionsController
    include DeviseFixes

    def create
      # Check
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)

        @resource = find_resource(field, q_value)

      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if resource_params[:login] =~ /^\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$/
          if @resource.phone_pin.nil?
            valid_password = false
          elsif @resource.phone_pin == resource_params[:password]
            valid_password = true
          else
            valid_password = false
            @resource.update_attribute(:phone_pin, nil)
          end
        else
          valid_password = @resource.valid_password?(resource_params[:password])
        end
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
          return render_create_error_bad_credentials
        end
        @token = @resource.create_token

        @resource.save
        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if @resource.respond_to?(:locked_at) && @resource.locked_at
          render_create_error_account_locked
        else
          render_create_error_not_confirmed
        end
      else
        render_create_error_bad_credentials
      end
    end

    def render_create_success
      render json: TerminalSerializer.new(@resource, {include: [:location]}).serialized_json, status: 200
      
      # render json: {
      #   data: resource_data(resource_json: @resource.token_validation_response)
      # }
    end
  end
end
