class ProductPricing < ActiveRecord::Base
  belongs_to :product_boxing

  validate  :quantityMostWithPrice
     
  def quantityMostWithPrice
    if quantity and price.blank?
      errors.add(:price, "請填寫價錢")
    end   
  end 
  
end
