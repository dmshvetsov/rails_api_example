class CreatePublisherShopsView < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      create view publisher_shops as
        select shops.id,
          shops.name,
          books.publisher_id,
          abs(sum(case
                    when stocks.quantity < 0 then stocks.quantity
                    else 0
                  end)) as books_sold_count
        from shops
          inner join shop_stock_changes as stocks on stocks.shop_id = shops.id
          inner join books on stocks.book_id = books.id
        group by shops.id, books.publisher_id
        ;
    SQL
  end

  def down
    execute <<~SQL
      drop view publisher_shops;
    SQL
  end
end
