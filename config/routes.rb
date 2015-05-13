Rails.application.routes.draw do
  

  get    'comments/post'  
  post   'comments/post'
  post   'comments/delete'
  post   'comments/reply'
  get    'comments/show'
  post   'comments/postSub'
  post   'comments/deleteSub'
  
  get    'carts/checkout'
  post   'carts/addCart'
  post   'carts/updateCart'  
  get    'carts/showCarts'  
  
  post   'users/mobileSMSConfirmationSend'
  get    'main/index'  
    
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                                       registrations: "registrations" }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation 
  match '/companies/:id/companyImagesUpload' => 'companies#companyImagesUpload', via: [:post], :as => :companyImagesUpload
  match '/companies/:id/companyImagesDelete' => 'companies#companyImagesDelete', via: [:delete], :as => :companyImagesDelete
  match '/products/:id/productImagesUpload' => 'products#productImagesUpload', via: [:post], :as => :productImagesUpload
  match '/products/:id/productImagesDelete' => 'products#productImagesDelete', via: [:delete], :as => :productImagesDelete
  match '/products/:id/available' => 'products#available', via: [:get], as: :available

  resources :products 
  resources :companies
  resources :users
  resources :carts, only: [:destroy] 
    
  root to: "main#index" 
end
