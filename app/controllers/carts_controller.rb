class CartsController < ApplicationController
  before_filter :authenticate_user!
  before_action only: [:destroy, :updateCart] { |c| c.CartCheckUser(params[:id])}              
  before_action :set_cart, only: [:destroy, :updateCart]

  def addCart
    product = ProductBoxing.find(params[:id]).product
    cart = current_user.carts.where(product_boxing_id: params[:id]).first        
    unless cart.blank?
      if cart.quantity + params[:quantity].to_i > 50      
        if request.xhr?
          render json: {alert_class: 'warning', message: '購買數量超過50箱'}             
        else
          flash[:warning] = '購買數量超過50箱'
          redirect_to product       
        end         
      else
        cart.quantity = cart.quantity + params[:quantity].to_i   
        cart.save!  
        if request.xhr?
          render json: {alert_class: 'success', message: '成功新增到購物車'}             
        else
          flash[:notice] = '成功新增到購物車'
          redirect_to product       
        end         
      end  
    else
      cart = Cart.new  
      cart.product_boxing = ProductBoxing.find(params[:id])
      cart.user = current_user
      cart.quantity = params[:quantity]    
      cart.save!  
      if request.xhr?
        render json: {alert_class: 'success', message: '成功新增到購物車'}             
      else
        flash[:notice] = '成功新增到購物車'
        redirect_to product       
      end        
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
          price = c.quantity*((p.price+shippingRates(cold_chain: p.product_boxing.product.cold_chain, size: p.product_boxing.size))*p.product_boxing.product.discount).ceil
          break  
        end  
      end     
      name = c.product_boxing.product.name
      if c.product_boxing.product.released_at
        if c.product_boxing.product.released_at > Time.now 
          name ='[預購]'+ c.product_boxing.product.name
        end
      end           
      carts << 
      {
        id: c.product_boxing.product.id,  
        name: name,
        quantity: c.quantity, 
        price: price.to_i,
        cart_id: c.id,
        image_url: c.product_boxing.product.cover.url(:medium)
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