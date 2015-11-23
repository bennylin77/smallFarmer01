class AddDeletedCToProductBoxings < ActiveRecord::Migration
  def self.up
    add_column :product_boxings, :deleted_c, :boolean, default: false, null: false    
    add_column :product_boxings, :deleted_at, :datetime
  end
  def self.down  
    remove_column :product_boxings, :deleted_c 
    remove_column :product_boxings, :deleted_at  
  end
end
