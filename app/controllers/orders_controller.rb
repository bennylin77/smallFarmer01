class OrdersController < ApplicationController  
  before_filter :authenticate_user!
  
  before_action only: [:confirm] { |c| c.OrderCheckUser(params[:id])}            
  before_action :set_order, only: [:confirm]
  
  def index    
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    @orders = Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1', current_user.companies.first, params[:called_smallfarmer_c] ).all.paginate(page: params[:page], per_page: 30).order('id')    
    render layout: 'companies'      
  end
  
  def confirm
    if !@order.called_smallfarmer_c
      @order.called_smallfarmer_c = true
      @order.called_smallfarmer_at = Time.now
      @order.shipments.each do  |s|
        s.status = GLOBAL_VAR['ORDER_STATUS_CONFIRMED']   
        s.save!
      end  
      @order.save!
      notficationRead( { user_id: current_user.id, category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], order_id: @order.id })
      #notify( @order.invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_UPDATING_INVOICE'], 
      #                               order_id: @order.id, content: '您購買的 "'+@order.product_boxing.product.name+'" 農夫已處理'})       
    end      
    flash[:notice] ='已通知物流'        
    redirect_to  controller: 'orders', action: 'index', called_smallfarmer_c: 'false'     
  end
  
  private   
    def set_order
      @order = Order.find(params[:id])
    end
     
    def user_params
      accessible = [ :first_name, :last_name, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                              invoices_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                   :receiver_county, :receiver_district, :receiver_address, :receiver_country]]# extend with your own params
      params.require(:user).permit(accessible)
    end  
end
