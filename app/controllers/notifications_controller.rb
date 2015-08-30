class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action only: [:read, :review] { |c| c.NotificationCheckUser(params[:id]) }            
  before_action :set_notification, only: [:read, :review]


  def index
    if params[:category] != 'all'
      @notifications = current_user.notifications.where(category: params[:category]).paginate(page: params[:page], per_page: 30).order('id desc')
    else
      @notifications = current_user.notifications.paginate(page: params[:page], per_page: 30).order('id desc')      
    end  
  end

  def read
    @notification.read_c = true
    @notification.read_at = Time.now
    @notification.save!
    render json: { success: true, unread_size: current_user.notifications.where(read_c: false).size }
  end

  def showNotifications
    render json: { quantity: current_user.notifications.where(read_c: false).size }
  end

  def review    
    invoice = @notification.invoice     
    if invoice.coupon.blank?
      params[:orders_id].each_with_index do |o, index|
        order = Order.find(o)
        order.shipment_review_score = params[:shipment_review_scores][index].to_i
        order.review_score = params[:review_scores][index].to_i
        order.review_feedback = params[:review_feedbacks][index]
        order.review_at = Time.now
        order.save!    
      end
      # important !!!!!!!!!!!!!!!!      
      discount = 0 
      invoice.invoice_coupon_lists.each do |i_c_l|
        discount = discount + i_c_l.amount
      end         
      coupon = Coupon.new
      coupon.user = current_user
      coupon.invoice = invoice      
      coupon.kind = GLOBAL_VAR['COUPON_CHECK_OUT']
      coupon.amount = ((invoice.amount - discount)*0.04).round
      coupon.original_amount = ((invoice.amount - discount)*0.04).round
      coupon.save!
      @notification.read_c = true
      @notification.read_at = Time.now
      @notification.save!
      render json: {type: 'success', message: '恭喜您獲得'+coupon.amount.to_i.to_s+'元 無期限回饋金'}            
    else   
      render json: {type: 'warning', message: '您已評論過'}      
    end   
     
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:category, :sub_category, :content, :order_id, :user_id, :comment_id, :product_id, :invoice_id)
    end
end
