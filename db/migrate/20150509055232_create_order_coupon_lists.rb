class CreateOrderCouponLists < ActiveRecord::Migration
  def change
    create_table :order_coupon_lists do |t|
      t.float :amount
      t.belongs_to :order, index: true
      t.belongs_to :coupon, index: true
      t.timestamps
    end
  end
end
