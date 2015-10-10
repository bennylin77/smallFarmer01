class AddColumnsToKeywords < ActiveRecord::Migration
  def self.up
    add_attachment :keywords, :cover 
    add_column :keywords, :description, :text 
    add_column :keywords, :available_c, :boolean, default: true, null: false 
       
  end
  def self.down  
    remove_attachment :keywords, :cover    
    remove_column :keywords, :description
    remove_column :keywords, :available_c
    
  end
end
