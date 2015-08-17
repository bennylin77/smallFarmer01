class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.belongs_to :user, index: true

      t.boolean   :confirmed_c, default: false, null: false 
      t.boolean   :canceled_c, default: false, null: false
      t.datetime  :canceled_at
      t.boolean   :paid_c, default: false, null: false                                      
      t.datetime  :paid_at
      
      t.float     :payment_charge_fee, default: 0, null: false 
      t.string    :allpay_trade_no
      t.string    :allpay_merchant_trade_no
      t.string    :allpay_bank_code
      t.string    :allpay_v_account
      t.datetime  :allpay_expired_at
      t.string    :allpay_payment_no
      t.integer   :payment_method          
      t.float     :amount, default: 0, null: false
      
      t.string    :receipt_c, default: false, null: false      
      t.string    :receipt_received_from
      t.string    :receipt_VAT_no
      t.string    :receipt_postal
      t.string    :receipt_county
      t.string    :receipt_district                        
      t.string    :receipt_address 
      t.string    :receipt_country       
                
      t.timestamps    
    end
  end
end
