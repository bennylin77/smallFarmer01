class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        address = @user.addresses.first
        address.first_name = @user.first_name
        address.last_name = @user.last_name     
        address.save!  
        flash[:notice] ='成功更改個人資料'
        format.html { redirect_to edit_user_path }
      else
        format.html { redirect_to edit_user_path  }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  def mobileSMSConfirmation 
    if request.patch? && params[:token] 
      @phone_no = params[:phone_no_full]  
      address = current_user.addresses.first
      if params[:token] == address.phone_no_confirmation_token
        address.phone_no = @phone_no
        address.phone_no_confirmed_at = Time.now
        address.save!
        # important !!!!!!!!!!!!!!!!
        if current_user.coupons.where(kind: GLOBAL_VAR['COUPON_SIGN_UP']).first.blank?       
          coupon = Coupon.new
          coupon.user = current_user
          coupon.kind = GLOBAL_VAR['COUPON_SIGN_UP']
          coupon.amount = 30
          coupon.original_amount = 30
          coupon.save!
          flash[:success] = '您已成功驗證, 並獲得30元回饋金' 
        else
          flash[:alert] = '您已驗證過, 謝謝！'                          
        end       
        redirect_to root_url                  
      else
        flash[:alert] = '驗證錯誤, 請重新驗證, 謝謝！'          
      end
    end    
    @phone_no = params[:phone_no]      
  end  
  
  def mobileSMSConfirmationSend
    address = current_user.addresses.first
    unless params[:phone_no].blank?
      unless address.phone_no_confirmation_frequency == 5
        token = Random.rand(10000...99999)
        address.phone_no_confirmation_token = token
        address.phone_no_confirmation_frequency = address.phone_no_confirmation_frequency + 1
        address.save!
        #System.sendConfirmation(current_user).deliver   
        data = { username: Rails.configuration.mitake_username, 
                 password: Rails.configuration.mitake_password,
                 dstaddr: params[:phone_no]  } 
        #result = RestClient.get( Rails.configuration.mitake_sm_send_get_url, data)    

        
        
        render json: {alert_class: 'success', message: '已送出您的驗證碼, 您將在數分鐘內收到'}          
      else
        render json: {alert_class: 'alert', message: '您的驗證已嘗試超過五次，請直接聯絡客服人員，謝謝！'}       
      end    
    else
      render json: {alert_class: 'error', message: '您未輸入任何電話'}        
    end     
  end    

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params[:user][:addresses_attributes]['0'][:phone_no] = params[:phone_no_full]
      accessible = [ :first_name, :last_name, :avatar,addresses_attributes:[:id, :first_name, :last_name, :phone_no, :postal, :county, :district, :address, :country] ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end