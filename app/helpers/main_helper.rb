module MainHelper
  
  def coupon
    coupon = 0
    current_user.coupons.each do |c|
      coupon = coupon + c.amount        
    end 
    coupon.to_i
  end
  
end
