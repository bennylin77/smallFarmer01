class AddAppliedToCompanies < ActiveRecord::Migration

  def self.up
    add_column :companies, :applied_c, :boolean, default: false, null: false 
    add_column :companies, :applied_at, :datetime
  end
  def self.down  
    remove_column :companies, :applied_c
    remove_column :companies, :applied_at  
  end        
end
