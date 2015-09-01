class AddColumnsToProductsAndCompanies < ActiveRecord::Migration
  def self.up
    add_column :products, :priority, :integer, default: 0, null: false 
    add_column :companies, :priority, :integer, default: 0, null: false     
  end
  def self.down    
    remove_column :products, :priority
    remove_column :companies, :priority
  end  
end
