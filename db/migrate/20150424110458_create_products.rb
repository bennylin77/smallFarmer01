class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string    :name
      t.text      :description
      t.integer   :inventory
      t.integer   :daily_capacity
      t.integer   :unit      
      t.boolean   :deleted_c, default: false, null: false
      t.datetime  :deleted_at       
      t.boolean   :available_c, default: false, null: false
      t.datetime  :available_at  
                  
      t.boolean   :cold_chain, default: false, null: false
      t.datetime  :cold_chain             
      
      t.belongs_to :company, index: true
      t.text       :preservation

      t.integer :sweet_degree
      t.boolean :GAP_c, default: false, null: false      
      t.boolean :TAP_c, default: false, null: false
      t.boolean :OTAP_c, default: false, null: false
      t.boolean :UTAP_c, default: false, null: false
      
      t.string  :short_URL
      
      t.timestamps
    end
  end
end
