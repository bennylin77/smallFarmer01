module ApplicationHelper
  
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
  
  def showBlank(s)
    if s.blank?
      '--'
    else  
      simple_format( s, {}, wrapper_tag: "span")
    end
  end   
end
