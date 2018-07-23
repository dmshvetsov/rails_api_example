class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  def error_404(exeption)
    render json: { error: exeption.message }, status: 404
  end
end
