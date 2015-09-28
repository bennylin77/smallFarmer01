class AddGiftWrappingCToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :gift_wrapping_c, :boolean, default: 0, null: false 
  end
  def self.down  
    remove_column :orders, :gift_wrapping_c
  end 
end
