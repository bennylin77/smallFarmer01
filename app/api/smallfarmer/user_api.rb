module Smallfarmer
  class USER_API < Grape::API
    version 'v1', using: :path
    format :json    
    prefix :user_api   
    helpers Smallfarmer::ApplicationHelpers
    
    before do
      error!("授權失敗", 401) unless authenticated
    end
    
    desc "Logout"   
    params do
      requires :mobile_os, type: Integer, desc: "Mobile os"       
    end        
    post :logout do  
      case params[:mobile_os].to_i
      when GLOBAL_VAR['OS_ANDROID']        
        user_device = UserDevice.where( os: GLOBAL_VAR['OS_ANDROID'], registration_id: params[:registration_id], user: current_user).first
        unless user_device.blank? 
          user_device.destroy
        end           
      when GLOBAL_VAR['OS_IOS']          
      end           
      { id: current_user.id }              
    end 
    
    desc "Show user"
    params do
      requires :user_id, type: Integer, desc: "User id"
    end        
    post :show do
      if params[:user_id] == params[:id].to_i
        user = current_user
      else  
        user = User.select("id, email, last_name, first_name, phone_no, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at").find(params[:user_id])
      end     
      user_avatar = ""
      if !user.avatar.blank?
        user_avatar = Rails.configuration.smallfarmer01_host + user.avatar.url
      end
      { user: user, user_avatar: user_avatar }   
    end    
    
       
  end
end       