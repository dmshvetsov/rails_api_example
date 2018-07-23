Rails.application.routes.draw do
  # JSON API
  defaults format: :json do
    namespace :v1 do
      get '/publishers/:publisher_id/shops', to: 'publishers_shops#index'
    end
  end
end
