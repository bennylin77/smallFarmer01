class OrdersController < ApplicationController
  
  def index    
    render layout: 'companies'      
  end
  
  def checkout   
    unless params[:user].blank?
      current_user.assign_attributes(user_params)   
    else
      current_user.orders.build()
    end                              
    @coupon_using = params[:coupons_using]
    @payment_method = params[:payment_method]
    @agree = params[:agree]    
  end
  
  def confirmCheckout   
    params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
    params[:user][:orders_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]    
    current_user.assign_attributes(user_params)  
    @coupon_using = params[:coupons_using]
    @payment_method = params[:payment_method]
    @agree = params[:agree]
    
    current_user.valid?
    if @payment_method.blank?  
      current_user.errors.add(:payment_method, "請選擇付款方式")
    end    
    unless @agree  
      current_user.errors.add(:agree, "請勾選 小農1號 電子商務約定條款")
    end
    if current_user.errors.any?
      render 'checkout'
    else
    end
  end  
  
  private   
    def user_params
      #params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
      #params[:user][:orders_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]
      accessible = [ :first_name, :last_name, :avatar, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                                       orders_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                          :receiver_county, :receiver_district, :receiver_address, :receiver_country]]# extend with your own params
      params.require(:user).permit(accessible)
    end  
end
