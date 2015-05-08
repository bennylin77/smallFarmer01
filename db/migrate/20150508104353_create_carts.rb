class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :quantity
      t.belongs_to :user, index: true
      t.belongs_to :product_boxing, index: true

      t.timestamps
    end
  end
end
