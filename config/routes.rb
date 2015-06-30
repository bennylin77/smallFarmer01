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
  post   'invoices/create'
  get    'invoices/allpayCredit'
  post   'invoices/allpayCreditNotify'
  get    'invoices/finished'    
  
  post   'orders/confirmCheckout'  
  post   'orders/checkout'
  get    'orders/index'

  post   'carts/addCart'
  post   'carts/updateCart'  
  get    'carts/showCarts'  
  
  post   'users/mobileSMSConfirmationSend'
  get    'main/index'  
  get    'main/delivered'

  get    'management/index'    
  get    'management/invoices'
  get    'management/orders'  
  get    'management/callLogistics'
                                       
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation 
  match '/companies/:id/companyImagesUpload' => 'companies#companyImagesUpload', via: [:post], :as => :companyImagesUpload
  match '/companies/:id/companyImagesDelete' => 'companies#companyImagesDelete', via: [:delete], :as => :companyImagesDelete
  match '/products/:id/productImagesUpload' => 'products#productImagesUpload', via: [:post], :as => :productImagesUpload
  match '/products/:id/productImagesDelete' => 'products#productImagesDelete', via: [:delete], :as => :productImagesDelete
  match '/products/:id/available' => 'products#available', via: [:get], as: :available
  match '/orders/:id/confirm' => 'orders#confirm', via: [:get], as: :confirm
  match '/orders/:id/cancel' => 'orders#cancel', via: [:get], as: :cancel

 
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                                       registrations: "registrations" }
  resources :products 
  resources :companies
  resources :notifications, only: [:index]     
  resources :orders, only: [:index]   
  resources :users, only: [:show, :edit, :update]
  resources :carts, only: [:destroy] 

  #devise_scope :user do
  #  delete "/logout" => "devise/sessions#destroy"
  #end      
  get    'main/marketing'
    
  root to: "main#index" 
end
