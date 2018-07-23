require 'rails_helper'

RSpec.describe Shop::StockChange, type: :model do
  describe '::decrease' do
    it 'creates stock change record' do
      shop = create(:shop, id: 12)
      book = create(:book, id: 638)
      Shop::StockChange.create!(shop: shop, book: book, quantity: 100)

      expect do
        Shop::StockChange.decrease(shop_id: 12, book_id: 638, quantity: -2)
      end.to change(Shop::StockChange, :count).by(1)

      created_record = Shop::StockChange.order('created_at DESC').first
      expect(created_record).to have_attributes(
        shop_id: 12,
        book_id: 638,
        quantity: -2
      )
    end

    it 'saves the quantity as a negative number' do
      shop = create(:shop, id: 12)
      book = create(:book, id: 638)
      Shop::StockChange.create!(shop: shop, book: book, quantity: 100)

      created_record = Shop::StockChange.decrease(
        shop_id: 12,
        book_id: 638,
        quantity: 33
      )
      expect(created_record.quantity).to eq(-33)
    end

    it 'raise error if trying to decrease more than currently in stock' do
      shop = create(:shop, id: 12)
      book = create(:book, id: 638)
      Shop::StockChange.create!(shop: shop, book: book, quantity: 1)

      expect do
        Shop::StockChange.decrease(shop_id: 12, book_id: 638, quantity: 2)
      end.to raise_error(Shop::InsufficientAmount)
    end
  end
end
