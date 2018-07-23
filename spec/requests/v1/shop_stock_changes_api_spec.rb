require 'rails_helper'

RSpec.describe 'Shop stock changes API', type: :request do
  describe 'POST /shops/:shop_id/book_sales' do
    it 'responds with JSON content type' do
      book = create(:book, id: 1)
      shop = create(:shop, id: 1)
      create(:shop_stock_change, shop: shop, book: book, quantity: 1)

      params = { book_id: 1, quantity: 1 }
      post '/v1/shops/1/book_sales', params: params
      expect(response.content_type).to eq('application/json')
    end

    it 'respond with status 201' do
      book = create(:book, id: 1)
      shop = create(:shop, id: 1)
      create(:shop_stock_change, shop: shop, book: book, quantity: 1)

      params = { book_id: 1, quantity: 1 }
      post '/v1/shops/1/book_sales', params: params
      expect(response).to have_http_status(201)
    end

    it 'should mark one or multiple copies of a book in a specific shop as sold' do
      book = create(:book, id: 523)
      shop = create(:shop, id: 1)
      create(:shop_stock_change, shop: shop, book: book, quantity: 2)

      params = { book_id: 523, quantity: 2 }
      expect do
        post '/v1/shops/1/book_sales', params: params
      end.to change(Shop::StockChange, :count).by(1)

      created_stock_change = Shop::StockChange.order('created_at DESC').first
      expect(created_stock_change).to have_attributes(
        shop_id: 1,
        book_id: 523,
        quantity: -2
      )
    end

    it 'respond with created record of stock change' do
      book = create(:book, id: 523)
      shop = create(:shop, id: 1)
      create(:shop_stock_change, shop: shop, book: book, quantity: 2)

      params = { book_id: 523, quantity: 1 }
      expect do
        post '/v1/shops/1/book_sales', params: params
      end.to change(Shop::StockChange, :count).by(1)

      created_stock_change = Shop::StockChange.order('created_at DESC').first
      expect(response.body).to eq(created_stock_change.to_json)
    end

    context 'when there is no shop with given id' do
      it 'respond with status 404' do
        book = create(:book, id: 1)

        params = { book_id: 1, quantity: 1 }
        post '/v1/shops/123/book_sales', params: params
        expect(response).to have_http_status(404)
      end

      it 'respond with error object' do
        book = create(:book, id: 1)

        params = { book_id: 1, quantity: 1 }
        post '/v1/shops/123/book_sales', params: params
        expect(response_json).to eq(
          'error' => "Couldn't find Shop with 'id'=123"
        )
      end

      it 'should not create changes record' do
        book = create(:book, id: 1)

        params = { book_id: 1, quantity: 1 }
        expect do
          post '/v1/shops/1/book_sales', params: params
        end.to change(Shop::StockChange, :count).by(0)
      end
    end

    context 'when there is no book with given id' do
      it 'respond with status 404' do
        shop = create(:shop, id: 1)

        params = { book_id: 12, quantity: 2 }
        post '/v1/shops/1/book_sales', params: params
        expect(response).to have_http_status(404)
      end

      it 'respond with error object' do
        shop = create(:shop, id: 1)

        params = { book_id: 12, quantity: 2 }
        post '/v1/shops/1/book_sales', params: params
        expect(response_json).to eq(
          'error' => "Couldn't find Book with 'id'=12"
        )
      end

      it 'should not create changes record' do
        shop = create(:shop, id: 1)

        params = { book_id: 12, quantity: 2 }
        expect do
          post '/v1/shops/1/book_sales', params: params
        end.to change(Shop::StockChange, :count).by(0)
      end
    end

    context 'when there is not enough books' do
      it 'respond with status 422' do
        book = create(:book, id: 1)
        shop = create(:shop, id: 1)
        create(:shop_stock_change, shop: shop, book: book, quantity: 1)

        params = { book_id: 1, quantity: 2 }
        post '/v1/shops/1/book_sales', params: params
        expect(response).to have_http_status(422)
      end

      it 'respond with error object' do
        book = create(:book, id: 1)
        shop = create(:shop, id: 1)
        create(:shop_stock_change, shop: shop, book: book, quantity: 1)

        params = { book_id: 1, quantity: 2 }
        post '/v1/shops/1/book_sales', params: params
        expect(response_json).to eq(
          'error' => 'Insufficient amount, you requested 2, 1 is available'
        )
      end

      it 'should not create changes record' do
        book = create(:book, id: 523)
        shop = create(:shop, id: 1)
        create(:shop_stock_change, shop: shop, book: book, quantity: 1)

        params = { book_id: 523, quantity: 2 }
        expect do
          post '/v1/shops/1/book_sales', params: params
        end.to change(Shop::StockChange, :count).by(0)
      end
    end
  end
end
