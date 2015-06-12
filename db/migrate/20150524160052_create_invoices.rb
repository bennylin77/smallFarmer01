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

      t.integer   :payment_method          
      t.float     :amount, default: 0, null: false 
      t.string    :receiver_last_name
      t.string    :receiver_first_name
      t.string    :receiver_phone_no
      t.string    :receiver_postal
      t.string    :receiver_county
      t.string    :receiver_district                        
      t.string    :receiver_address 
      t.string    :receiver_country

      t.timestamps
    end
  end
end
