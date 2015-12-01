class AddSgsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :SGS_c, :boolean, default: 0, null: false   
  end
  def self.down  
    remove_column :products, :SGS_c
  end
end
