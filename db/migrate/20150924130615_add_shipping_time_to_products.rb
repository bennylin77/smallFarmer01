class AddShippingTimeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :shipping_time, :integer, default: 0, null: false 
  end
  def self.down  
    remove_column :products, :shipping_time
  end 
end
