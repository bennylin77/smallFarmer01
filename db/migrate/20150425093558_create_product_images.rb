class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.attachment :image
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end
