class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_404
  rescue_from Shop::InsufficientAmount, with: :error_422

  def error_404(exeption)
    render json: { error: exeption.message }, status: 404
  end

  def error_422(exeption)
    render json: { error: exeption.message }, status: 422
  end
end
