class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :body_html
      t.string :image
      t.decimal :price
      t.decimal :compare_at_price  
      t.decimal :cost   
      t.string :sku
      t.string :barcode
      t.boolean :tracked
      t.boolean :continue_selling
      t.integer :available
      t.decimal :weight
      t.decimal :weight_unit
      t.string :countries
      t.integer :inventory_quantity
      t.integer :inventory_item_id
      t.string :inventory_management
      t.string :inventory_policy
      t.string :location_id
      t.string :location
      t.boolean :requires_shipping
      t.string :fulfillment_service
      t.integer :quantity
      t.integer :incoming
      t.string :product_type
      t.string :vendor
      t.timestamps
    end
  end
end
 