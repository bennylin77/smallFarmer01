class AddGiftWrappingAvailableCToProductBoxings < ActiveRecord::Migration
  def self.up
    add_column :product_boxings, :gift_wrapping_available_c, :boolean, default: 0, null: false  
  end
  def self.down  
    remove_column :product_boxings, :gift_wrapping_available_c
  end 
end
