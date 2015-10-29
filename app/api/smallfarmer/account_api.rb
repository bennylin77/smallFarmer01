module Smallfarmer
  class ACCOUNT_API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :account_api

    resource :auth do       
      desc "Creates and returns access_token if valid sign in"
      params do
        requires :email, type: String, desc: "Email address"
        requires :password, type: String, desc: "Password"
      end     
      post :signIn do           
        user = User.find_for_authentication(email: params[:email])         
        if user && user.valid_password?(params[:password])
          # expired?
          if user.authentication_token.blank?
            user.reset_authentication_token
          elsif user.expired?
            user.reset_authentication_token
          end  
          # device
          case params[:mobile_os].to_i
          when GLOBAL_VAR['OS_ANDROID']  
            unless params[:registration_id].blank? 
              user_device = UserDevice.where( os: GLOBAL_VAR['OS_ANDROID'], registration_id: params[:registration_id]).first
              if user_device.blank?
                user_device = UserDevice.new
                user_device.os = GLOBAL_VAR['OS_ANDROID']
                user_device.registration_id = params[:registration_id]   
              end      
            else
              error!('請輸入registration_id', 401)  
            end       
          when GLOBAL_VAR['OS_IOS']          
          end       
          user_device.user = user
          user_device.save!                
          { id: user.id, token: user.authentication_token }
        else
          error!('錯誤的帳號或密碼', 401)
        end
      end    
      
      desc "Creates and returns access_token if valid facebook sign in"
      params do
        requires :fb_token, type: String, desc: "Facebook token"
      end     
      post :facebookSignIn do                 
        data = { access_token: params[:fb_token] }                                   
        result = RestClient.get( Rails.configuration.facebook_graph_me_url, params: data)                  
        result = JSON.parse(result)
        if  result["error"].blank?  
          identity = Identity.where(provider: 'facebook', uid: result["id"]).first        
          if !identity.blank?
            user = identity.user
            # expired?
            if user.expired? or user.authentication_token.blank?
              user.reset_authentication_token
            end  
            # device
            case params[:mobile_os].to_i
            when GLOBAL_VAR['OS_ANDROID']  
              unless params[:registration_id].blank? 
                user_device = UserDevice.where( os: GLOBAL_VAR['OS_ANDROID'], registration_id: params[:registration_id]).first
                if user_device.blank?
                  user_device = UserDevice.new
                  user_device.os = GLOBAL_VAR['OS_ANDROID']
                  user_device.registration_id = params[:registration_id]   
                end      
              else
                error!('請輸入registration_id', 401)  
              end       
            when GLOBAL_VAR['OS_IOS']          
            end       
            user_device.user = user
            user_device.save!                
            { id: user.id, token: user.authentication_token }
          else
            error!( '0', 401 ) 
          end
        else
          error!('錯誤的FB token', 401)        
        end    
      end          
      
      
    end  
  end
end  