Rails.application.routes.draw do
  # JSON API
  defaults format: :json do
    namespace :v1 do
      get '/publishers/:publisher_id/shops', to: 'publishers_shops#index'
      post '/shops/:shop_id/book_sales', to: 'shops_book_sales#create'
    end
  end
end
