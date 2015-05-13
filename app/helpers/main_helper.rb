module MainHelper
  
  def coupons
    coupons = 0
    current_user.coupons.each do |c|
      coupon = coupon + c.amount        
    end 
    coupons.to_i
  end
  
  def carts
    quantity = 0
    current_user.carts.each do |c| 
      quantity = quantity + c.quantity
    end 
    quantity ==0 ? "":quantity   
  end
  
end
