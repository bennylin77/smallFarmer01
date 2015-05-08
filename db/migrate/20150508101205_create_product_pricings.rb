class CreateProductPricings < ActiveRecord::Migration
  def change
    create_table :product_pricings do |t|
      t.integer :quantity
      t.float :price
      t.belongs_to :product_boxing, index: true

      t.timestamps
    end
  end
end
