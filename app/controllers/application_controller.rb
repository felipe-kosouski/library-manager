class ApplicationController < ActionController::Base
  include ErrorHandler
  def authorize_librarian!
    unless current_user.librarian?
      redirect_to root_path, alert: "Access denied.", status: :unauthorized
    end
  end

  def authorize_member!
    unless current_user.member?
      redirect_to root_path, alert: "Access denied.", status: :unauthorized
    end
  end

  def route_not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end
end
