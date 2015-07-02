class MainController < ApplicationController
  def index
    
  end
  
  def delivered 
    order = Order.find(params[:id])
    order.delivered_c = true
    order.delivered_at = Time.now 
    order.status = GLOBAL_VAR['ORDER_STATUS_DELIVERED'] 
    order.save! 
    delivered_all = true
    order.invoice.orders.each do |o|
      if !o.delivered_c   
        delivered_all = false       
      end
    end       
    if delivered_all
      notify( order.invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW'], 
                                    invoice_id: order.invoice.id})               
    end  
    redirect_to root_url    
  end
  
  def marketing
    
  end
  
end
