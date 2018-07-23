require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '#sell_book' do
    it 'calls Shop::StockChange::decrease' do
      create(:book, id: 8)
      shop = create(:shop, id: 10)

      expect(Shop::StockChange).to receive(:decrease)
        .with(shop_id: 10, book_id: 8, quantity: 3)

      shop.sell_book(book_id: 8, quantity: 3)
    end

    it 'does not allow to sell zero or negative number of books' do
      create(:book, id: 8)
      shop = create(:shop, id: 10)

      expect do
        shop.sell_book(book_id: 8, quantity: -1)
      end.to raise_error(Shop::NotPositiveQuantity)

      expect do
        shop.sell_book(book_id: 8, quantity: 0)
      end.to raise_error(Shop::NotPositiveQuantity)
    end
  end
end
