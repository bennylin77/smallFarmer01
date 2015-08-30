class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?  
  
  #before_filter :ensure_signup_complete, only: [:new, :create, :edit, :update, :destroy]
    
  [:Company, :Product, :User].each do |model|
    class_eval %Q{
      def #{model}CheckUser(id)
       unless #{model}.where(id: id).first == nil      
         case '#{model}'
         when 'Company'       
           if #{model}.find(id).user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url          
           end  
         when 'Product'  
           if #{model}.find(id).company.user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url          
           end            
         end     
       else
        flash["error"]="項目不存在"
        redirect_to root_url        
       end    
      end
    }
  end  
  
  def emptyCarts?
    if current_user.carts.size == 0
      flash['alert'] = '購物車內沒有商品喔!'
      redirect_to root_url
    end
  end
  
  def shippingRates(hash={})
    shipping_rates = 0
    case hash[:size]
    when GLOBAL_VAR['BOX_SIZE_FIRST']
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_FIRST'] 
      shipping_rates = shipping_rates + (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL'] ? GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'] : 0)  
    when GLOBAL_VAR['BOX_SIZE_SECOND']
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_SECOND']   
      shipping_rates = shipping_rates + (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL'] ? GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN'] : 0)      
    when GLOBAL_VAR['BOX_SIZE_THIRD']
      shipping_rates = GLOBAL_VAR['SHIPPING_RATES_THIRD']       
    end
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
    devise_parameter_sanitizer.for(:sign_up)  { |u| 
      u.permit(:first_name, :last_name, :password, :password_confirmation, :email) 
    }
  end  
  
  def notify( user, hash={} )
    user.notifications<< Notification.create(hash)
    user.save!   
  end
  
  def notficationRead(hash)
    notification = Notification.where(hash).first
    notification.read_c = true
    notification.read_at = Time.now
    notification.save!
  end
 
end
