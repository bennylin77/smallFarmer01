module ApplicationHelper
  def coupons
    coupons = 0
    current_user.coupons.each do |c|
      coupons = coupons + c.amount        
    end 
    coupons.to_i
  end
  
  def carts
    quantity = 0
    current_user.carts.each do |c| 
      quantity = quantity + c.quantity
    end 
    quantity == 0 ? "" : quantity   
  end  
  
  def active(hash={})     
    if current_page?(hash)
      "class='active'".html_safe     
    end
  end  
end
