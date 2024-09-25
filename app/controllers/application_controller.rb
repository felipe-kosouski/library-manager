class ApplicationController < ActionController::Base
  layout :handle_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ErrorHandler

  def route_not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end

  protected

  def handle_layout
    if current_user&.librarian?
      "admin/application"
    else
      "application"
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
