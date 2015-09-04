class ProductPricing < ActiveRecord::Base
  belongs_to :product_boxing

  validate  :quantityMostWithPrice, on: :update 
  validate  :moreThanOneMostWithLowerPrice, on: :update 
  validate  :onlyOneQuantityWithOne

     
  def quantityMostWithPrice
    if quantity and price.blank?
      errors.add(:price, "請填寫價錢")
    end   
    if quantity.blank? and price
      errors.add('product_pricings.quantity', "請填寫促箱箱數")
    end      
  end 
  
  def moreThanOneMostWithLowerPrice
    one = self.product_boxing.product_pricings.where(quantity: 1).first    
    if quantity 
      if quantity > 1
        if !one.price.blank? and !price.blank?
          if one.price <= price
            errors.add(:price, "'每箱'促銷價錢須低於原價")       
          end
        end
      end
    end   
  end   

  def onlyOneQuantityWithOne
    if self.product_boxing
      if self.product_boxing.product_pricings.where(quantity: 1).first != self
        if self.quantity
          if self.quantity <= 1
            self.quantity = 0
            errors.add(:quantity, "促銷箱數需大於1")
          end
        end
      end
    end  
  end

end
