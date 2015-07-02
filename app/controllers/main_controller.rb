class MainController < ApplicationController
  def index
    
  end
  
  def delivered 
    order = Order.find(params[:id])
    order.delivered_c = true
    order.delivered_at = Time.now 
    order.status = GLOBAL_VAR['ORDER_STATUS_DELIVERED'] 
    order.save!

    notify( order.invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW'], 
                                  order_id: order.id})         
    
    redirect_to root_url    
  end
  
  def marketing
    
  end
  
end
