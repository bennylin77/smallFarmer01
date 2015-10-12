class AddPreorderCToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :preorder_c, :boolean, default: false, null: false    
  end
  def self.down  
    remove_column :orders, :preorder_c  
  end
end
