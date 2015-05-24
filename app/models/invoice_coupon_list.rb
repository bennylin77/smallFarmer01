class InvoiceCouponList < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :invoice  
end
