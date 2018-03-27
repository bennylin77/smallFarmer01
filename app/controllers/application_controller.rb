class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  #before_filter :ensure_signup_complete, only: [:new, :create, :edit, :update, :destroy]

  [:Company, :Product, :User, :Bill, :Notification, :Order, :Cart, :Comment, :SubComment, :Invoice].each do |model|
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
         when 'User'
           if #{model}.find(id) != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Bill'
           if #{model}.find(id).company.user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Notification'
           if #{model}.find(id).user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Order'
           if #{model}.find(id).product_boxing.product.company.user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Invoice'
           if #{model}.find(id).user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Cart'
           if #{model}.find(id).user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'Comment'
           if #{model}.find(id).user != current_user
              flash["error"]="您沒有權限"
              redirect_to root_url
           end
         when 'SubCommentCheckUser'
           if #{model}.find(id).user != current_user
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

  def priceWithShippingRates(hash={})
    price = 0
    hash[:product_boxing].product_pricings.order('quantity desc').each do |p|
      if hash[:quantity] >= p.quantity
        shipping_rate_quantity = 1
        if p.quantity != 1
          shipping_rate_quantity = p.quantity
        end
        price = hash[:quantity]*((p.price + shippingRates(cold_chain: hash[:product_boxing].product.cold_chain, box_size: hash[:product_boxing].size, quantity: shipping_rate_quantity))*hash[:product_boxing].product.discount).ceil
        break
      end
    end
    price
  end

  def shippingRates(hash={})
    shipping_rates = 0
    case hash[:box_size]
    when GLOBAL_VAR['BOX_SIZE_FIRST']
      if hash[:quantity] == 1
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_FIRST'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_FIRST'];
      else
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['BARGAIN_SHIPPING_RATES_FIRST'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['BARGAIN_SHIPPING_RATES_FIRST'];
      end
    when GLOBAL_VAR['BOX_SIZE_SECOND']
      if hash[:quantity] == 1
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_SECOND'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_SECOND'];
      else
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['BARGAIN_SHIPPING_RATES_SECOND'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['BARGAIN_SHIPPING_RATES_SECOND'];
      end
    when GLOBAL_VAR['BOX_SIZE_THIRD']
        shipping_rates = (hash[:cold_chain] != GLOBAL_VAR['SHIPMENT_TEMP_NORMAL']) ? (GLOBAL_VAR['SHIPPING_RATES_THIRD'] + GLOBAL_VAR['SHIPPING_RATES_COLD_CHAIN']):GLOBAL_VAR['SHIPPING_RATES_THIRD'];
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
    devise_parameter_sanitizer.permit(:account_update) { |u|
      u.permit(:password, :password_confirmation, :current_password)
    }
    devise_parameter_sanitizer.permit(:sign_up)  { |u|
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
    notification.read_at = Time.zone.now
    notification.save!
  end

  def pushAndroidNotification(hash)
    registration_ids = []
    hash[:user].user_devices.each do |u_d|
      registration_ids << u_d.registration_id
    end
    unless registration_ids.blank?
      n = Rpush::Gcm::Notification.new
      n.app = Rpush::Gcm::App.find_by_name("android_app")
      n.registration_ids = registration_ids
      n.data = { title: hash[:title], message: hash[:message] }
      n.save!
    end
  end
end
