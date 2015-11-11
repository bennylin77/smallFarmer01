class AddOrganicToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :organic, :integer, default: 0, null: false    
  end
  def self.down  
    remove_column :products, :organic
  end
end
