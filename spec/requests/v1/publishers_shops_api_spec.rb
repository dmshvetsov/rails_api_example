require 'rails_helper'

RSpec.describe 'Publisher Shops API', type: :request do
  describe 'GET /publisher/:publisher_id/shops' do
    it 'responds with JSON content type' do
      Publisher.create!(id: 1)
      get '/v1/publishers/1/shops'
      expect(response.content_type).to eq('application/json')
    end

    it 'respond with a list of shops selling at least one book of a given publisher' do
      publisher = Publisher.create!(id: 1)
      shop_a = Shop.create!(name: 'A')
      Shop.create!(name: 'B')
      book1 = Book.create!(publisher: publisher, title: '1')
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: 50)

      get '/v1/publishers/1/shops'

      expected = [{
        id: shop_a.id,
        name: shop_a.name,
        books_sold_count: 0,
        books_in_stock: [{
          id: book1.id,
          title: book1.title,
          copies_in_stock: 50
        }]
      }].to_json
      expect(response.body).to eq(expected)
    end

    it 'should filter results by given publisher id' do
      publisher = Publisher.create!(id: 3420)
      other_publisher = Publisher.create!(id: 5502)
      shop_a = Shop.create!(name: 'A')
      shop_b = Shop.create!(name: 'B')
      book = Book.create!(publisher: publisher, title: '1')
      other_book = Book.create!(publisher: other_publisher, title: '1')
      Shop::StockChange.create!(shop: shop_a, book: book, quantity: 150)
      Shop::StockChange.create!(shop: shop_a, book: other_book, quantity: 30)
      Shop::StockChange.create!(shop: shop_b, book: other_book, quantity: 55)

      get '/v1/publishers/3420/shops'

      expected = [{
        id: shop_a.id,
        name: shop_a.name,
        books_sold_count: 0,
        books_in_stock: [{
          id: book.id,
          title: book.title,
          copies_in_stock: 150
        }]
      }].to_json
      expect(response.body).to eq(expected)
    end

    it 'should list all books for each shops with a given publisher' do
      publisher = Publisher.create!(id: 1)
      shop_a = Shop.create!(name: 'A')
      shop_b = Shop.create!(name: 'B')
      book1 = Book.create!(publisher: publisher, title: '1')
      book2 = Book.create!(publisher: publisher, title: '2')
      book3 = Book.create!(publisher: publisher, title: '3')
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: 51)
      Shop::StockChange.create!(shop: shop_a, book: book2, quantity: 52)
      Shop::StockChange.create!(shop: shop_a, book: book3, quantity: 1)
      Shop::StockChange.create!(shop: shop_b, book: book3, quantity: 53)

      get '/v1/publishers/1/shops'

      expect(response_json.size).to eq(2)

      shop_a_json, shop_b_json = response_json

      expected_shop_a_json = [
        { id: book1.id, title: book1.title, copies_in_stock: 51 },
        { id: book2.id, title: book2.title, copies_in_stock: 52 },
        { id: book3.id, title: book3.title, copies_in_stock: 1 }
      ].as_json
      expect(shop_a_json['books_in_stock']).to eq(expected_shop_a_json)

      expected_shop_b_json = [
        { id: book3.id, title: book3.title, copies_in_stock: 53 }
      ].as_json
      expect(shop_b_json['books_in_stock']).to eq(expected_shop_b_json)
    end

    it 'should order shops by the number of books sold' do
      publisher = Publisher.create!(id: 1)
      shop_a = Shop.create!(name: 'A')
      shop_b = Shop.create!(name: 'B')
      shop_c = Shop.create!(name: 'C')
      book1 = Book.create!(publisher: publisher, title: '1')
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: 10)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -3)
      Shop::StockChange.create!(shop: shop_b, book: book1, quantity: 6)
      Shop::StockChange.create!(shop: shop_b, book: book1, quantity: -1)
      Shop::StockChange.create!(shop: shop_c, book: book1, quantity: 5)
      Shop::StockChange.create!(shop: shop_c, book: book1, quantity: -4)

      get '/v1/publishers/1/shops'

      expect(
        response_json.map { |shop| shop.fetch('name') }
      ).to eq(['C', 'A', 'B'])
    end

    it 'should aggreagte number of books sold by shop' do
      publisher = Publisher.create!(id: 1)
      shop_a = Shop.create!(name: 'A')
      book1 = Book.create!(publisher: publisher, title: '1')
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: 1000)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -1)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -1)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -1)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -2)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -20)

      get '/v1/publishers/1/shops'

      expect(response.body).to match('"books_sold_count":25')
    end

    it 'should\'t include shops that sold all copies' do
      publisher = Publisher.create!(id: 1)
      shop_a = Shop.create!(name: 'A')
      book1 = Book.create!(publisher: publisher, title: '1')
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: 1)
      Shop::StockChange.create!(shop: shop_a, book: book1, quantity: -1)

      get '/v1/publishers/1/shops'

      expect(response.body).to eq('[]')
    end

    context 'when there is no publisher' do
      it 'responds with error object' do
        get '/v1/publishers/2923/shops'
        expect(response_json).to eq(
          'error' => "Couldn't find Publisher with 'id'=2923"
        )
      end

      it 'respond with status 200' do
        get '/v1/publishers/2923/shops'
        expect(response).to have_http_status(404)
      end
    end

    context 'when there is no shops with publishers books in stock' do
      it 'responds with empty array' do
        Publisher.create!(id: 1)
        get '/v1/publishers/1/shops'
        expect(response.body).to eq('[]')
      end

      it 'respond with status 200' do
        Publisher.create!(id: 1)
        get '/v1/publishers/1/shops'
        expect(response).to have_http_status(200)
      end
    end
  end
end
