class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    # authorize! :read, @user
  end

  def edit
    # authorize! :update, @user
  end

  def update
    # authorize! :update, @user
    if @user.update(user_params)
      sign_in(@user == current_user ? @user : current_user, :bypass => true)
      flash[:notice] ='成功更改個人資料'
      redirect_to controller: 'users', action: 'edit', id: current_user
    else
      render 'edit'
    end
  end

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
=begin
  def mobileSMSConfirmation 
    if request.patch? && params[:token] 
      if params[:token] == current_user.phone_no_confirmation_token
        current_user.phone_no = current_user.phone_no_for_confirmation
        current_user.phone_no_confirmed_at = Time.now
        current_user.save!
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
    if current_user.phone_no_confirmed_at.blank? 
      unless params[:phone_no].blank?
        unless current_user.phone_no_confirmation_frequency == 5
          token = Random.rand(10000...99999)
          current_user.phone_no_for_confirmation = params[:phone_no]
          current_user.phone_no_confirmation_token = token
          current_user.phone_no_confirmation_frequency = current_user.phone_no_confirmation_frequency + 1
          current_user.save!
          #System.sendConfirmation(current_user).deliver   
          data = { username: Rails.configuration.mitake_username, 
                   password: Rails.configuration.mitake_password,
                   dstaddr: params[:phone_no].gsub(/^\+886/, '0'),
                   encoding: 'UTF8',
                   smbody: '小農1號行動電話驗證，您的簡訊驗證碼為:'+token.to_s
                   } 
          result = RestClient.get( Rails.configuration.mitake_sm_send_get_url, params: data)        
          render json: {alert_class: 'success', message: '已送出您的驗證碼, 您將在數分鐘內收到'}          
        else
          render json: {alert_class: 'warning', message: '您的驗證已嘗試超過五次，請直接聯絡客服人員，謝謝！'}       
        end    
      else
        render json: {alert_class: 'warning', message: '您未輸入任何電話'}        
      end 
    else
      render json: {alert_class: 'warning', message: '您已驗證通過'}  
    end        
  end    
=end
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
      params[:user][:phone_no] = params[:phone_no_full]
      accessible = [ :first_name, :last_name, :avatar, :phone_no, :email] 
      #accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end