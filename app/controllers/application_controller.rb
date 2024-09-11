class ApplicationController < ActionController::Base
  include ErrorHandler

  def route_not_found
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}"
  end
end
