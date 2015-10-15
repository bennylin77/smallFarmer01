Rails.application.routes.draw do
  

  get    'comments/post'  
  post   'comments/post'
  post   'comments/delete'
  post   'comments/reply'
  get    'comments/show'
  post   'comments/postSub'
  post   'comments/deleteSub'
  
  get    'coupons/index'
  get    'coupons/showCoupons'

  get    'companies/apply'
  post   'companies/apply'
  
  get    'invoices/index'
  post   'invoices/create'
  post   'invoices/confirmCheckout'  
  post   'invoices/checkout'  
  get    'invoices/allpayCredit'
  get    'invoices/allpayATM'
  get    'invoices/allpayCVS'  
  post   'invoices/allpayNotify'  
  post   'invoices/allpayPaymentInfoNotify'
  get    'invoices/finished'   
  get    'invoices/cancel'    
     
  get    'orders/index'
  
  get    'bills/index'

  get    'carts/addCart'
  get    'carts/updateCart'  
  get    'carts/showCarts'  
  
  get    'notifications/showNotifications'
  post   'notifications/review'    
  
  #post   'users/mobileSMSConfirmationSend'
  
  get    'main/typeaheadSource'
  get    'main/index'  
  get    'main/search'
  get    'main/fruits'
  get    'main/farms' 
  get    'main/getFruitsAndFarms'  
  get    'main/showCartsNotifications'
  get    'main/privacyPolicy'
  get    'main/returnPolicy'  
  get    'main/serviceIntro'

  get    'management/bills'   
  get    'management/billShow'     
  get    'management/invoices'
  get    'management/orders'
  get    'management/setOrder'  
  get    'management/setShipment'  
  get    'management/callLogistics'
  get    'management/delivered'  
  get    'management/problem'
  post   'management/exportOrders'
  post   'management/uploadTracking' 
  get    'management/shipments'       
  get    'management/companies'  
  get    'management/setCompany'   
  get    'management/activateCompany'  
  get    'management/updateBankCode'
  get    'management/updateBankAccount'
  get    'management/products'  
  get    'management/setProduct'   
  get    'management/users'  
  get    'management/blockUser' 
  get    'management/confirmPhoneNo'
  get    'management/coupons'
  get    'management/giveCoupon'
  post   'management/giveCoupon'  
  get    'management/keywords' 
  get    'management/keywordEdit'
  post   'management/updateKeyword'
     
                              
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  #match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation 

  match '/companies/preview/:id' => 'companies#preview', via: [:patch]
  match '/companies/:id/companyCoverUpload' => 'companies#companyCoverUpload', via: [:post], :as => :companyCoverUpload
  match '/companies/:id/companyCoverDelete' => 'companies#companyCoverDelete', via: [:post], :as => :companyCoverDelete  
  match '/companies/:id/companyImagesUpload' => 'companies#companyImagesUpload', via: [:post], :as => :companyImagesUpload
  match '/companies/:id/companyImagesDelete' => 'companies#companyImagesDelete', via: [:post], :as => :companyImagesDelete
  match '/products/preview/:id' => 'products#preview', via: [:patch]   
  match '/products/:id/productCoverUpload' => 'products#productCoverUpload', via: [:post], :as => :productCoverUpload
  match '/products/:id/productCoverDelete' => 'products#productCoverDelete', via: [:post], :as => :productCoverDelete    
  match '/products/:id/productImagesUpload' => 'products#productImagesUpload', via: [:post], :as => :productImagesUpload
  match '/products/:id/productImagesDelete' => 'products#productImagesDelete', via: [:post], :as => :productImagesDelete
  match '/products/:id/available' => 'products#available', via: [:get], as: :available
  match '/orders/:id/confirm' => 'orders#confirm', via: [:get], as: :confirm
  match '/management/:id/keywordCoverUpload' => 'management#keywordCoverUpload', via: [:post], :as => :keywordCoverUpload
  match '/management/:id/keywordCoverDelete' => 'management#keywordCoverDelete', via: [:post], :as => :keywordCoverDelete 

  match '/notifications/:id/read' => 'notifications#read', via: [:get], as: :read
 
 
 
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
  get    'main/fb'  
  get    'main/under'  
  get    'main/surveyFarmer'
  get    'main/tempIndex'

  mount  Smallfarmer::ORDER_API => '/'    
  mount  Smallfarmer::ACCOUNT_API => '/'  
  mount  Smallfarmer::USER_API => '/'    
  mount  Smallfarmer::USER_DEVICE_API => '/'  
  mount  Smallfarmer::BILL_API => '/'  
  mount  Smallfarmer::COMPANY_API => '/'   
    
  root to: "main#tempIndex" 
end
