class ProductBoxing < ActiveRecord::Base
  belongs_to :product
  has_many   :product_pricings, dependent: :destroy     
  has_many   :carts, dependent: :destroy     
    
  accepts_nested_attributes_for :product_pricings  
  
end
