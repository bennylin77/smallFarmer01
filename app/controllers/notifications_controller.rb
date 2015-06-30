class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]


  def index
    @notifications = Notification.all
  end

  def show
  end

  def new
    @notification = Notification.new
  end

  def edit
  end

  def create
    @notification = Notification.new(notification_params)
    @notification.save
  end

  def update
    @notification.update(notification_params)
  end

  def destroy
    @notification.destroy
  end

  private
    def set_notification
      @notification = Notification.find(params[:id])
    end

    def notification_params
      params.require(:notification).permit(:category, :sub_category, :content, :order_id, :user_id, :comment_id, :product_id, :invoice_id)
    end
end
