class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :product_id
      t.string :variant_id
      t.string :title
      t.decimal :price
      t.integer :quantity
      t.integer :grams
      t.string :financial_status
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :country
       t.string :country_id
      t.string :city
      t.string :address1
      t.string :address2
      t.string :zip
      t.string :province 
      
      t.timestamps
    end
  end
end
