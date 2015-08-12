class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      
      t.belongs_to :company, index: true      
      t.string    :title

      t.string    :user_first_name        
      t.string    :user_last_name             
      t.string    :company_name      
      t.string    :company_phone_no
      t.string    :company_postal
      t.string    :company_county
      t.string    :company_district                        
      t.string    :company_address 
      t.string    :company_country

      t.string    :bank_code     
      t.string    :bank_account

      t.float     :total_sales, default: 0, null: false
      t.float     :total_shipping_fees, default: 0, null: false
      t.float     :total_cash_flow_fees, default: 0, null: false
      t.float     :total_administration_fees, default: 0, null: false
      t.float     :total_coupon_fees, default: 0, null: false
      t.float     :sales_tax, default: 0, null: false    
      t.float     :transfer_fee, default: 0, null: false      
      
      t.datetime  :begin_at
      t.datetime  :end_at
      
      
      t.timestamps
    end
  end
end
