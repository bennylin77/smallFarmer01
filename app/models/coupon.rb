class Coupon < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  
  has_many   :order_coupon_list, dependent: :destroy   
  
end
