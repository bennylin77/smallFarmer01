class ProductPricing < ActiveRecord::Base
  belongs_to :product_boxing

  validate  :quantityMostWithPrice, on: :update 
  validate  :moreThanOneMostWithLowerPrice, on: :update 

     
  def quantityMostWithPrice
    if quantity and price.blank?
      errors.add(:price, "請填寫價錢")
    end   
  end 
  
  def moreThanOneMostWithLowerPrice
    one = self.product_boxing.product_pricings.where(quantity: 1).first    
    if quantity 
      if quantity > 1
        if !one.price.blank? and !price.blank?
          if one.price <= price
            errors.add(:price, "'每箱'促銷價錢須低於一般價錢")       
          end
        end
      end
    end   
  end   
  
end
