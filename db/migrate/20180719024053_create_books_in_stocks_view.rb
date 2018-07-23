class CreateBooksInStocksView < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      create view books_in_stocks as

        select books.id,
          books.title,
          books.publisher_id,
          stocks.shop_id,
          sum(stocks.quantity) as copies_in_stock
        from books
          inner join shop_stock_changes as stocks on stocks.book_id = books.id
        group by books.id, shop_id
          having copies_in_stock > 0
        ;
    SQL
  end

  def down
    execute <<~SQL
      drop view books_in_stocks;
    SQL
  end
end
