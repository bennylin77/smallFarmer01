class AddAcceptTheTermsOfUseCToFarms < ActiveRecord::Migration
  def self.up
    add_column :companies, :accept_the_terms_of_use_c, :boolean, default: false, null: false 
    add_column :companies, :accept_the_terms_of_use_at, :datetime
  end
  def self.down    
  end    
end
