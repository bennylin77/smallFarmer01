class Invoice < ActiveRecord::Base
  belongs_to :user
  
  has_many :orders  
  has_many :invoice_coupon_lists
  has_many :notifications  
  has_one  :coupon
  
  accepts_nested_attributes_for :orders 
         
end
