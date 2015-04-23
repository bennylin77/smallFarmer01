class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user
      
      t.string   :first_name
      t.string   :last_name 
      
      t.string   :phone_no
      t.string   :phone_no_confirmation_token
      t.datetime :phone_no_confirmed_at
      t.integer  :phone_no_confirmation_frequency, default: 0, null: false      
      
      t.string   :postal
      t.string   :county
      t.string   :district                        
      t.string   :address 
      t.string   :country
      t.timestamps
    end
  end
end
