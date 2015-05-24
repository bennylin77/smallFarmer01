class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :product_boxing, index: true      
      t.belongs_to :invoice, index: true     

      t.boolean   :agreed_c, default: false, null: false  
      
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
