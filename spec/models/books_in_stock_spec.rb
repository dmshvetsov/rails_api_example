require 'rails_helper'

RSpec.describe BooksInStock, type: :model do
  it 'returns no books if books is not awailable in shops' do
    expect(
      BooksInStock.all
    ).to be_empty
  end

  it 'returns all book that available in shops' do
    book1 = create(:book, title: 'book1')
    book2 = create(:book, title: 'book2')
    book3 = create(:book, title: 'book3')
    shop_a = create(:shop, id: 1)
    shop_b = create(:shop, id: 2)
    create(:shop, id: 3)
    create(:shop_stock_change, book: book1, shop: shop_a, quantity: 1)
    create(:shop_stock_change, book: book2, shop: shop_a, quantity: 1)
    create(:shop_stock_change, book: book3, shop: shop_a, quantity: 1)
    create(:shop_stock_change, book: book1, shop: shop_b, quantity: 1)
    expect(
      BooksInStock.all.pluck(:title, :shop_id)
    ).to match_array([['book1', 1], ['book2', 1], ['book3', 1], ['book1', 2]])
  end

  it 'returns amount of books that available in shops' do
    book1 = create(:book, title: 'book1')
    book2 = create(:book, title: 'book2')
    book3 = create(:book, title: 'book3')
    shop = create(:shop, id: 1)
    create(:shop_stock_change, book: book1, shop: shop, quantity: 10)
    create(:shop_stock_change, book: book2, shop: shop, quantity: 2)
    create(:shop_stock_change, book: book3, shop: shop, quantity: 1)
    expect(
      BooksInStock.all.pluck(:title, :copies_in_stock)
    ).to match_array([['book1', 10], ['book2', 2], ['book3', 1]])
  end

  it 'does not returns books that ended' do
    book = create(:book, title: 'book1')
    shop = create(:shop, id: 1)
    create(:shop_stock_change, book: book, shop: shop, quantity: 2)
    create(:shop_stock_change, book: book, shop: shop, quantity: -2)
    expect(
      BooksInStock.all.pluck(:title, :copies_in_stock)
    ).to be_empty
  end
end
