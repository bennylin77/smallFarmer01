class OrdersController < ApplicationController  
  before_filter :authenticate_user!
  
  before_action only: [:confirm, :confirmAndShippedBySelf] { |c| c.OrderCheckUser(params[:id])}            
  before_action :set_order, only: [:confirm, :confirmAndShippedBySelf]
  
  def index    
    params[:called_smallfarmer_c] = params[:called_smallfarmer_c] == 'true' ? true : false    
    if params[:called_smallfarmer_c]
      @orders = Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1 and invoices.canceled_c = 0', current_user.companies.first, params[:called_smallfarmer_c] ).all.paginate(page: params[:page], per_page: 30).order('id desc')        
    else
      @orders = Order.joins(product_boxing: {product: :company}, invoice: {} ).where('companies.id = ? and called_smallfarmer_c = ? and invoices.confirmed_c = 1 and invoices.canceled_c = 0', current_user.companies.first, params[:called_smallfarmer_c] ).all.paginate(page: params[:page], per_page: 30).order('id')    
    end
    render layout: 'companies'      
  end
  
  def confirm
    if !@order.called_smallfarmer_c
      @order.called_smallfarmer_c = true
      @order.called_smallfarmer_at = Time.zone.now
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
  
  def confirmAndShippedBySelf
    if !@order.called_smallfarmer_c
      @order.called_smallfarmer_c = true
      @order.called_smallfarmer_at = Time.zone.now
      @order.called_logistics_c = true
      @order.called_logistics_at = Time.zone.now 
      @order.save!
                  
      @order.shipments.each do  |s|
        s.delivered_c = true
        s.delivered_at = Time.zone.now         
        s.status = GLOBAL_VAR['ORDER_STATUS_SHIPPED_BY_COMPANY']   
        s.save!                                
        #bills
        company = s.order.product_boxing.product.company   
        bill = company.bills.where("end_at >= ?", Time.zone.now).first
        if bill.blank?
          bill = Bill.new
          if Time.zone.now.day <= 15          
            bill.begin_at = Date.civil(Time.zone.now.year, Time.zone.now.month, 1).midnight
            bill.end_at = Date.civil(Time.zone.now.year, Time.zone.now.month, 16).midnight-1
          else
            bill.begin_at = Date.civil(Time.zone.now.year, Time.zone.now.month, 16).midnight
            bill.end_at = ( Date.civil(Time.zone.now.year, Time.zone.now.month, -1)+1 ).midnight-1    
          end  
          bill.title = '小農一號合作農場帳單表'
          bill.company = company
        end
        bill.orders << s.order
        bill.save!            
        #review
        if s.order.review_at.blank? and s.order.invoice.notifications.where(category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW']).count == 0
          delivered_all = true          
          s.order.invoice.orders.each do |i_o|
            i_o.shipments.each do |ss| 
              if !ss.delivered_c
                delivered_all = false       
              end
            end
          end      
          if delivered_all
            notify( s.order.invoice.user, { category: GLOBAL_VAR['NOTIFICATION_PROMOTION'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_REVIEW'], 
                                            invoice_id: s.order.invoice.id}) 
            System.sendReviewNotification( s.order.invoice ).deliver           
            invoice = s.order.invoice
            discount = 0 
            invoice.invoice_coupon_lists.each do |i_c_l|
              discount = discount + i_c_l.amount
            end       
          end
        end         
      end  
      notficationRead( { user_id: current_user.id, category: GLOBAL_VAR['NOTIFICATION_PRODUCT'], sub_category: GLOBAL_VAR['NOTIFICATION_SUB_NEW_ORDER'], order_id: @order.id })
    end      
    flash[:notice] ='已確認自行出貨'        
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
