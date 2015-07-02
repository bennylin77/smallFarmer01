class NotificationsController < ApplicationController
  before_action :set_notification, only: [:read, :review]


  def index
    @notifications = current_user.notifications.order('id desc')
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
      invoice.orders.each_with_index do |o, index|
        o.review_score = params[:review_scores][index]
        o.review_feedback = params[:review_feedbacks][index]
        o.review_at = Time.now
        o.save!    
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
      render json: {type: 'success', message: '您獲得'+coupon.amount.to_i.to_s+'元'}            
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
