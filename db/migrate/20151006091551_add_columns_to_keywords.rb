class AddColumnsToKeywords < ActiveRecord::Migration
  def self.up
    add_attachment :keywords, :cover 
    add_column :keywords, :description, :text    
  end
  def self.down  
    remove_attachment :keywords, :cover    
    remove_column :keywords, :description
  end
end
