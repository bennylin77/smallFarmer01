class Order < ActiveRecord::Base
  
  belongs_to :product_boxing
  belongs_to :invoice
  
  has_many :order_receiver_addresses

end
