class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]


  def index
    @notifications = current_user.notifications
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:category, :sub_category, :content, :order_id, :user_id, :comment_id, :product_id, :invoice_id)
    end
end
