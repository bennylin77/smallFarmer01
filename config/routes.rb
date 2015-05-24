Rails.application.routes.draw do
  

  get    'comments/post'  
  post   'comments/post'
  post   'comments/delete'
  post   'comments/reply'
  get    'comments/show'
  post   'comments/postSub'
  post   'comments/deleteSub'
  
  get    'coupons/index'

  get    'invoices/index'
  post   'invoices/createCredit'
  post   'invoices/createCOD'
  
  post   'orders/confirmCheckout'  
  post   'orders/checkout'
  get    'orders/index'
  get    'orders/finished'  
  
  post   'carts/addCart'
  post   'carts/updateCart'  
  get    'carts/showCarts'  
  
  post   'users/mobileSMSConfirmationSend'
  get    'main/index'  
    
                                     
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation 
  match '/companies/:id/companyImagesUpload' => 'companies#companyImagesUpload', via: [:post], :as => :companyImagesUpload
  match '/companies/:id/companyImagesDelete' => 'companies#companyImagesDelete', via: [:delete], :as => :companyImagesDelete
  match '/products/:id/productImagesUpload' => 'products#productImagesUpload', via: [:post], :as => :productImagesUpload
  match '/products/:id/productImagesDelete' => 'products#productImagesDelete', via: [:delete], :as => :productImagesDelete
  match '/products/:id/available' => 'products#available', via: [:get], as: :available
 
 
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                                       registrations: "registrations" }
  resources :products 
  resources :companies
  resources :users, only: [:show, :edit, :update]
  resources :carts, only: [:destroy] 

  #devise_scope :user do
  #  delete "/logout" => "devise/sessions#destroy"
  #end      
  root to: "main#index" 
end
