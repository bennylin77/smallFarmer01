class CartsController < ApplicationController
  before_action :set_cart, only: [:destroy, :updateCart]

  def checkout   
    @carts = current_user.carts
    current_user.orders.build()
  end
  
  def confirmCheckout   

  end  
  
  
  def addCart
    cart = current_user.carts.where(product_boxing_id: params[:id]).first        
    unless cart.blank?
      if cart.quantity + params[:quantity].to_i > 50
        render json: {alert_class: 'error', message: '購買數量超過50'}          
      else
        cart.quantity = cart.quantity + params[:quantity].to_i   
        cart.save!  
        render json: {alert_class: 'success', message: '成功更新購物車'}                    
      end  
    else
      cart = Cart.new  
      cart.product_boxing = ProductBoxing.find(params[:id])
      cart.user = current_user
      cart.quantity = params[:quantity]    
      cart.save!  
      render json: {alert_class: 'success', message: '成功更新購物車'}                
    end                       
  end
  
  def updateCart
    @cart.quantity = params[:quantity].to_i
    if @cart.save     
      render json: {alert_class: 'success', message: '成功更新購物車'}        
    else
      render json: {alert_class: 'error', message: '更新購物車失敗'}    
    end      
  end
  
  def showCarts
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