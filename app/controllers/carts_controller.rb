class CartsController < ApplicationController
  before_action :set_cart, only: [:destroy]

  def checkout 
    if request.post?
      cart = current_user.carts.where(product_boxing_id: params[:id]).first
      unless cart.blank?
        cart.quantity = cart.quantity + params[:quantity].to_i
      else
        cart = Cart.new  
        cart.product_boxing = ProductBoxing.find(params[:id])
        cart.user = current_user
        cart.quantity = params[:quantity]     
      end  
      cart.save           
    end
    @carts = current_user.carts
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
    price = 0
    current_user.carts.each do |c|
      c.product_boxing.product_pricings.order('quantity desc').each do |p|
        if c.quantity >= p.quantity 
          price = c.quantity*p.price
          break  
        end  
      end
      carts << 
      {
        name: c.product_boxing.product.name,
        quantity: c.quantity, 
        price: price.to_i
      }       
    end
    render json: carts.to_json    
  end
  
  
  def destroy
    @cart.destroy
    render json: {alert_class: 'success', message: '成功刪除'} 
  end
  
  private
    def set_cart
      @cart = Cart.find(params[:id])
    end  
end