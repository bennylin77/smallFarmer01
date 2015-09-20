class CreateUserDevices < ActiveRecord::Migration
  def change
    create_table :user_devices do |t|
      t.belongs_to :user, index: true
      t.integer :os  
      t.string :device_token
      t.string :registration_id
      
      t.timestamps
    end
    add_index :user_devices, :device_token, unique: true    
    add_index :user_devices, :registration_id, unique: true 
  end
end
