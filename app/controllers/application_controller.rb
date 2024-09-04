class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StandardError, with: :standard_error
  rescue_from ActionController::RoutingError, with: :record_not_found

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def standard_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end
end
