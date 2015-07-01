class NotificationsController < ApplicationController
  before_action :set_notification, only: [:read, :show, :edit, :update, :destroy]


  def index
    @notifications = current_user.notifications
  end

  def read
    @notification.read_c = true
    @notification.read_at = Time.now
    @notification.save!
    render json: { success: true, unread_size: current_user.notifications.where(read_c: false).size }
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:category, :sub_category, :content, :order_id, :user_id, :comment_id, :product_id, :invoice_id)
    end
end
