class RegistrationsController < Devise::RegistrationsController
  layout "users", only: [:edit, :update]  
  
  def create
    if verify_recaptcha
      super
    else
      build_resource(sign_up_params)
      clean_up_passwords(resource)
      flash.now[:alert] = "請告訴我您不是機器人"      
      flash.delete :recaptcha_error
      render :new
    end
  end
end