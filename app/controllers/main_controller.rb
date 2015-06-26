class MainController < ApplicationController
  def index
    
  end
  
  def delivered 
    order = Order.find(params[:id])
    order.delivered_c = true
    order.delivered_at = Time.now 
    order.status = GLOBAL_VAR['ORDER_STATUS_DELIVERED'] 
    order.save!
    redirect_to root_url    
  end
  
  
end
