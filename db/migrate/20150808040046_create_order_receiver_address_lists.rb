class CreateOrderReceiverAddressLists < ActiveRecord::Migration
  def change
    create_table :order_receiver_address_lists do |t|

      t.belongs_to :order, index: true 
      t.belongs_to :receiver_address, index: true       

      t.integer   :quantity  
      t.integer   :status 
      t.string    :tracing_code 
      t.integer   :t_cat_status
      t.datetime  :t_cat_status_updated_at  
      
      t.boolean   :delivered_c, default: false, null: false  
      t.datetime  :delivered_at 

      t.timestamps
    end
  end
end
