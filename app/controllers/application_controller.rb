class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from CanCan::AccessDenied, with: :render_not_authorized_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::StatementInvalid, with: :respond_with_errors
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_terminal)
  end

  def render_not_found_response(exception)
    render json: { errors: [{ detail: exception.message, title: I18n.t('api.errors.error_404'), status: 404 }] }, status: :not_found
  end

  def render_not_authorized_response(exception)
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    if current_terminal
      render json: { errors: [{ title: I18n.t('api.errors.error_403'), status: 403 }] }, status: 403
    else
      render json: { errors: [{ title: I18n.t('api.errors.error_401'), status: 401 }] }, status: 401
    end
  end

  def respond_with_errors(exception)
    if exception.respond_to?('errors')
      # Rails.logger.error exception.errors.inspect
      message = exception.errors.full_messages.join('; ')
    elsif exception.message
      # Rails.logger.error exception.message
      message = exception.message
    else
      message = I18n.t('activerecord.errors.unknown')
    end

    render json: { errors: [{ title: message, status: 422 }] }, status: :unprocessable_entity
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email name location_id])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email name location_id])
  end

end
