class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?  
    
  [:Company].each do |model|
    class_eval %Q{
      def #{model}CheckUser(id)
       unless #{model}.where(id: id).first == nil
         if #{model}.find(id).user != current_user
            flash["error"]="您沒有權限"
            redirect_to root_url          
         end  
       else
        flash["error"]="項目不存在"
        redirect_to root_url        
       end    
      end
    }
  end  
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end  

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| 
      u.permit(:password, :password_confirmation, :current_password) 
    }
  end  
  
end
