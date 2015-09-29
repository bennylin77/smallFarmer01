class AddProcessingNoteToShipments < ActiveRecord::Migration
  def self.up
    add_column :shipments, :processing_note, :string  
  end
  def self.down  
    remove_column :shipments, :processing_note  
  end 
end
