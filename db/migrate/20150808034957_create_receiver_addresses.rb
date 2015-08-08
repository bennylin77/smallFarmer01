class CreateReceiverAddresses < ActiveRecord::Migration
  def change
    create_table :receiver_addresses do |t|

      t.string    :last_name
      t.string    :first_name
      t.string    :phone_no
      t.string    :postal
      t.string    :county
      t.string    :district                        
      t.string    :address 
      t.string    :country
            
      t.timestamps
    end
  end
end
