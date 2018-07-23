class CreateShopStockChanges < ActiveRecord::Migration[5.2]
  def up
    create_table :shop_stock_changes do |t|
      t.references :shop, foreign_key: true, null: false
      t.references :book, foreign_key: true, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end

  def down
    drop_table :shop_stock_changes
  end
end
