class OrderReceiverAddressList < ActiveRecord::Base

  belongs_to :order
  belongs_to :receiver_address 
end
