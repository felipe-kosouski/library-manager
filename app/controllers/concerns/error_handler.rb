# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_content
    rescue_from ActionController::RoutingError, with: :handle_route_not_found
  end

  private

  def handle_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end

  def handle_unprocessable_content(exception)
    render json: { message: exception.message }, status: :unprocessable_content
  end

  def handle_route_not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end
end
