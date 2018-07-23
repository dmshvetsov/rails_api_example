class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.references :publisher, foreign_key: true, null: false

      t.timestamps
    end
  end
end
