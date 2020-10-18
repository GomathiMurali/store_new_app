class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.string :variant_id
      t.decimal :price
      t.integer :grams
      t.integer :quantity
      t.string :uid

      t.timestamps
    end
  end
end
