class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :product_boxing      
      t.belongs_to :invoice     
      
      t.string   :receiver_last_name
      t.string   :receiver_first_name
      t.string   :receiver_phone_no
      t.string   :receiver_postal
      t.string   :receiver_county
      t.string   :receiver_district                        
      t.string   :receiver_address 
      t.string   :receiver_country

      t.boolean   :confirm_c, default: false, null: false  
      t.boolean   :agree_c, default: false, null: false  
      t.boolean   :cancel_c, default: false, null: false        
      
      t.integer   :review_score
      t.string    :review_feedback      
      t.datetime  :review_at
      
      t.float     :price
      t.integer   :quantity     
      t.integer   :status 
            
      t.timestamps
    end
  end
end
