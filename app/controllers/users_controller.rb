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
        flash.now[:notice] ='成功更改個人資料'
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
    
  end  
  
  def mobileSMSConfirmationSend
    unless params[:phone_no].blank?
      unless current_user.phone_no_confirmation_frequency == 5
        token = Random.rand(10000...99999)
        current_user.phone_no_confirmation_token = token
        current_user.phone_no_confirmation_frequency = current_user.phone_no_confirmation_frequency + 1
        current_user.save!
        System.sendConfirmation(current_user).deliver   
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
      params[:user][:phone_no] = params[:phone_no_full]
      accessible = [ :first_name, :last_name, :phone_no, :postal, :county, :district, :address] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end