module Smallfarmer
  module ApplicationHelpers
    extend Grape::API::Helpers
    
    def warden
      env['warden']
    end
    
    def authenticated
      return true if warden.authenticated?        
      user = User.find( params[:id] )
      params[:access_token] && 
      Devise.secure_compare( user.authentication_token, params[:access_token] ) && 
      !user.expired? &&
      @user = user 
    end

    def current_user
      warden.user || @user
    end

    def notficationRead(hash)
      notification = Notification.where(hash).first
      notification.read_c = true
      notification.read_at = Time.zone.now
      notification.save!
    end
    
  end
end
