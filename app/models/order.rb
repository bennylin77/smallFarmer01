class Order < ActiveRecord::Base
  
  belongs_to :product_boxing
  belongs_to :invoice
  
  has_many :shipments

end
