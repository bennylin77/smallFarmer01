class CartsController < ApplicationController

  def checkout 
  end
  
  def addToCart 
    cart = current_user.carts.where(product_boxing_id: params[:id]).first
    unless cart.blank?
      cart.quantity = cart.quantity + params[:quantity].to_i
    else
      cart = Cart.new  
      cart.product_boxing = ProductBoxing.find(params[:id])
      cart.user = current_user
      cart.quantity = params[:quantity]     
    end  
    if cart.save     
      render json: {alert_class: 'success', message: '成功加入購物車'}        
    else
      render json: {alert_class: 'error', message: '加入購物車失敗'}    
    end                       
  end
  
  def showCart
    carts = Array.new
    current_user.carts.each do |c|
      carts << 
      {
        title: c.product_boxing.product.title,
        quantity: c.quantity, 
        price: c.quantity*c.product_boxing.product_pricings.first.price
      }     
      
    end
    render json: carts.to_json    
  end
  
end