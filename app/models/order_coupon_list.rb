class OrderCouponList < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :order  
end
