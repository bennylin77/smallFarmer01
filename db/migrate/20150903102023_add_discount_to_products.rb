class AddDiscountToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :discount, :float, default: 1, null: false 
  end
  def self.down    
    remove_column :products, :discount
  end  
end
