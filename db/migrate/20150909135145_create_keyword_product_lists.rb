class CreateKeywordProductLists < ActiveRecord::Migration
  def change
    create_table :keyword_product_lists do |t|
      t.belongs_to :product, index: true
      t.belongs_to :keyword, index: true
      t.timestamps
    end
  end
end
