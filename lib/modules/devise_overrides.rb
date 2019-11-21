# frozen_string_literal: true

require 'pp'

module DeviseFixes
  extend ActiveSupport::Concern
  # include DeviseTokenAuth::Controllers::Helpers

  def render_error(status, message, data = nil)
    response = {
      success: false,
      errors: [
        status: status,
        title: message
      ]
    }
    response = response.merge(data) if data
    render json: response, status: status
  end

  def find_resource(field, value)
    # fix for mysql default case insensitivity
    q = "#{field} = ? AND provider='#{provider}'"
    q = 'BINARY ' + q if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
    @resource = if field == :login
        resource_class.where(email: value).or(resource_class.where(name: value)).first
      else
        resource_class.where(q, value).first
      end
  end
end