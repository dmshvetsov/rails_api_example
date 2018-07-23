class V1::ShopsBookSalesController < ApplicationController
  def create
    shop = Shop.find(shop_id)
    stock_change = shop.sell_book(book_id: book_id, quantity: quantity)
    render json: stock_change, status: 201
  end

  private

  def shop_id
    params.require(:shop_id)
  end

  def book_id
    params.require(:book_id)
  end

  def quantity
    params.require(:quantity).to_i
  end
end
