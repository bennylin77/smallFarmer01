class Coupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :invoice
  
  has_many  :invoice_coupon_lists
  
end
