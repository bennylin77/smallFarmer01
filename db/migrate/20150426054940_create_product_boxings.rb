class CreateProductBoxings < ActiveRecord::Migration
  def change
    create_table :product_boxings do |t|
      t.integer :quantity
      t.string :unit
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
