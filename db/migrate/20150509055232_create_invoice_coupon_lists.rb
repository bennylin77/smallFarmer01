class CreateInvoiceCouponLists < ActiveRecord::Migration
  def change
    create_table :invoice_coupon_lists do |t|
      t.float :amount
      t.belongs_to :invoice, index: true
      t.belongs_to :coupon, index: true
      t.timestamps
    end
  end
end
