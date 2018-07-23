# = Books quantity changes in shops stocks
class Shop::StockChange < ApplicationRecord
  belongs_to :shop
  belongs_to :book

  class << self
    # Descrease amount of books
    def decrease(shop_id:, book_id:, quantity:)
      args = {
        shop_id: shop_id,
        book_id: book_id,
        quantity: quantity.abs * -1
      }
      check_sufficient_amoun(args)
      create(args)
    end

    private

    # Check if we have given book quantity in stock for given shop
    def check_sufficient_amoun(shop_id:, book_id:, quantity:)
      quantity = quantity.abs
      args = {
        shop_id: shop_id,
        book_id: book_id
      }
      in_stock = where(args).sum(:quantity).abs
      raise Shop::InsufficientAmount.new(quantity, in_stock) if in_stock < quantity
    end
  end
end
