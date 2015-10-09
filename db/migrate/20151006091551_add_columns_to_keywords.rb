class AddColumnsToKeywords < ActiveRecord::Migration
  def self.up
    add_attachment :keywords, :cover 
    add_column :keywords, :description, :text 
    add_column :keywords, :available_c, :boolean, default: false, null: false 
    add_column :keywords, :available_at, :datetime  
       
  end
  def self.down  
    remove_attachment :keywords, :cover    
    remove_column :keywords, :description
    remove_column :keywords, :available_c
    remove_column :keywords, :available_at   
    
  end
end
