class CreateVarients < ActiveRecord::Migration[6.0]
  def change
    create_table :varients do |t|
      t.decimal :price

      t.timestamps
    end
  end
end
