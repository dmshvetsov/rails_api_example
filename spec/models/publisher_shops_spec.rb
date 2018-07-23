require 'rails_helper'

RSpec.describe PublisherShop, type: :model do
  describe '::most_sold scope' do
    it 'returns ordered by books sold from most to least' do
      book = create(:book)
      shop1 = create(:shop, name: 'a')
      shop2 = create(:shop, name: 'b')
      shop3 = create(:shop, name: 'c')
      # increse
      create(:shop_stock_change, shop: shop1, book: book, quantity: 10)
      create(:shop_stock_change, shop: shop2, book: book, quantity: 45)
      create(:shop_stock_change, shop: shop3, book: book, quantity: 1)
      # decrease
      create(:shop_stock_change, shop: shop1, book: book, quantity: -2)
      create(:shop_stock_change, shop: shop2, book: book, quantity: -14)

      expect(
        PublisherShop.most_sold.map(&:name)
      ).to eq(['b', 'a', 'c'])
    end

    it 'returns ordered by name if sold count are equal' do
      book = create(:book)
      shop1 = create(:shop, name: 'a')
      shop2 = create(:shop, name: 'b')
      shop3 = create(:shop, name: 'c')
      create(:shop_stock_change, shop: shop1, book: book, quantity: 1)
      create(:shop_stock_change, shop: shop2, book: book, quantity: 1)
      create(:shop_stock_change, shop: shop3, book: book, quantity: 1)
      expect(
        PublisherShop.most_sold.map(&:name)
      ).to eq(['a', 'b', 'c'])
    end

    it 'should filter by passed params' do
      publisher1, publisher2 = create_list(:publisher, 2)
      book1 = create(:book, title: 'b1', publisher: publisher1)
      book2 = create(:book, title: 'b2', publisher: publisher2)
      shop1 = create(:shop, name: 'A')
      shop2 = create(:shop, name: 'B')
      create(:shop_stock_change, shop: shop1, book: book1, quantity: 1)
      create(:shop_stock_change, shop: shop1, book: book2, quantity: 1)
      create(:shop_stock_change, shop: shop2, book: book1, quantity: 1)
      create(:shop_stock_change, shop: shop2, book: book2, quantity: 1)

      expect(
        PublisherShop.most_sold(id: shop1.id).map(&:name)
      ).to match_array(['A'])
      expect(
        PublisherShop.most_sold(publisher_id: publisher2.id).map(&:name)
      ).to match_array(['A', 'B'])
      expect(
        PublisherShop.most_sold(publisher_id: publisher1.id, id: shop2.id).map(&:name)
      ).to match_array(['B'])
    end
  end
end
