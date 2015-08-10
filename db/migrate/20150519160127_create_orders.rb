class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :product_boxing, index: true      
      t.belongs_to :invoice, index: true     
      
      t.float     :price
      t.integer   :quantity     
      t.float     :shipping_rates  

      t.integer   :review_score
      t.integer   :shipment_review_score      
      t.string    :review_feedback      
      t.datetime  :review_at
                        
      t.boolean   :canceled_c, default: false, null: false
      t.datetime  :canceled_at              
      t.boolean   :called_smallfarmer_c, default: false, null: false
      t.datetime  :called_smallfarmer_at      
      t.boolean   :called_logistics_c, default: false, null: false  
      t.datetime  :called_logistics_at          
                        
      t.timestamps
    end
  end
end
