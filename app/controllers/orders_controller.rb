class OrdersController < ApplicationController
  
  def userIndex    
    render layout: 'users'    
  end
  
  def companyIndex    
    render layout: 'companies'      
  end
  
  def checkout   
    @carts = current_user.carts
    @user = current_user
    @user.orders.build()
  end
  
  def confirmCheckout   
    @carts = current_user.carts
    @user = current_user   
    if @user.update(user_params)
      
    else
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
