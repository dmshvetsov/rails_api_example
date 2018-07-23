FactoryBot.define do
  factory :shop_stock_change, class: 'Shop::StockChange' do
    shop
    book
    quantity 1
  end
end
