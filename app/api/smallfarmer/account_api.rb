module Smallfarmer
  class ACCOUNT_API < Grape::API
    version 'v1', using: :path
    format :json
    prefix :account_api

    resource :auth do       
      desc "Creates and returns access_token if valid login"
      params do
        requires :email, type: String, desc: "Email address"
        requires :password, type: String, desc: "Password"
      end     
      post :signIn do           
        user = User.find_for_authentication(email: params[:email])         
        if user && user.valid_password?(params[:password])
          if user.expired?
            user.reset_authentication_token
          end  
          { id: user.id, token: user.authentication_token }
        else
          error!('錯誤的帳號或密碼', 401)
        end
      end    
    end  
   
  end
end  