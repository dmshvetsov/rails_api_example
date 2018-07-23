class Shop < ApplicationRecord
  class InsufficientAmount < StandardError
    def initialize(requested, available)
      super("Insufficient amount, you requested #{requested}, #{available} is available")
    end
  end

  class NotPositiveQuantity < StandardError
    def initialize(msg = 'The quantity can not be zero or negative')
      super(msg)
    end
  end

  def sell_book(book_id:, quantity:)
    raise NotPositiveQuantity if quantity <= 0
    book = Book.find(book_id)
    Shop::StockChange.decrease(
      shop_id: id,
      book_id: book.id,
      quantity: quantity
    )
  end
end
