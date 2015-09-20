module Smallfarmer
  class USER_DEVICE_API < Grape::API
    version 'v1', using: :path
    format :json    
    prefix :user_device_api   
    helpers Smallfarmer::ApplicationHelpers
    
    before do
      error!("授權失敗", 401) unless authenticated
    end
    
    desc "Update user device"   
    params do
      requires :mobile_os, type: Integer, desc: "Mobile os" 
      optional :old_registration_id, type: String   
      optional :new_registration_id, type: String       
      optional :old_device_token, type: String      
      optional :new_device_token, type: String               
    end        
    post :update do
      case params[:mobile_os].to_i
      when GLOBAL_VAR['OS_ANDROID']        
        user_device = UserDevice.where( os: GLOBAL_VAR['OS_ANDROID'], registration_id: params[:old_registration_id], user: current_user).first
        unless user_device.blank? 
          user_device.destroy
          user_device = UserDevice.new
          user_device.os = GLOBAL_VAR['OS_ANDROID']
          user_device.registration_id = params[:new_registration_id]        
          user_device.user = current_user
          user_device.save!             
        end           
      when GLOBAL_VAR['OS_IOS']          
      end           
      { id: current_user.id}           
    end 
  end
end 