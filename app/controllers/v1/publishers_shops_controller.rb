# = Concreate publisher API
class V1::PublishersShopsController < ApplicationController
  def index
    Publisher.find(publisher_id)
    render json: data
  end

  private

  def data
    books_in_stock = BooksInStock.where(publisher_id: publisher_id).group_by(&:shop_id)
    shops = PublisherShop.most_sold(id: books_in_stock.keys)

    Response.new(shops: shops, books_in_stock: books_in_stock)
  end

  def publisher_id
    params[:publisher_id]
  end

  # Response for publisher shops API
  class Response
    BOOKS_ATTRS = %i[id title copies_in_stock].freeze

    def initialize(shops: [], books_in_stock: {})
      @shops = shops
      @books_in_stock = books_in_stock
    end

    def as_json(options = nil)
      shops.map do |shop|
        shop_books = books_in_stock[shop.id].as_json(only: BOOKS_ATTRS)
        {
          id: shop.id,
          name: shop.name,
          books_sold_count: shop.books_sold_count,
          books_in_stock: shop_books
        }
      end
    end

    private

    attr_reader :shops, :books_sold, :books_in_stock
  end
end
