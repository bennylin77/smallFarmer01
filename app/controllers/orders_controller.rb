class OrdersController < ApplicationController
  
  def userIndex    
    render layout: 'users'    
  end
  
  def companyIndex    
    render layout: 'companies'      
  end
  
  def checkout   
    current_user.orders.build()
  end
  
  def confirmCheckout   
    @user = current_user 
    @user.assign_attributes(user_params)  
    @user.valid?

    @user.carts.each do |c|
      logger.info params['quantity_'+c.id.to_s]  
    end
    if params[:payment_method].blank?  
      @user.errors.add(:payment_method, "請選擇付款方式")
    end    
    unless params[:agree]  
      @user.errors.add(:agree, "請勾選 小農1號 電子商務約定條款")
    end
  
    
    if @user.errors.any?
      @coupon_using = params[:coupons_using]
      @payment_method = params[:payment_method]
      @agree = params[:agree]
      render 'checkout'
    end
  end  
  
  private   
    def user_params
      params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
      params[:user][:orders_attributes]['0'][:receiver_phone_no] = params[:receiver_phone_no_full]
      accessible = [ :first_name, :last_name, :avatar, addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country],
                                                       orders_attributes:[:id, :receiver_last_name, :receiver_first_name, :receiver_phone_no, :receiver_postal, 
                                                                          :receiver_county, :receiver_district, :receiver_address, :receiver_country]]# extend with your own params
      params.require(:user).permit(accessible)
    end  
end
