Rails.application.routes.draw do
  
  resources :products

  post 'users/mobileSMSConfirmationSend'
  get  'main/index'  
  
  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                                       registrations: "registrations" }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation
  match '/companies/:id/companyImagesUpload' => 'companies#companyImagesUpload', via: [:post], :as => :companyImagesUpload
  match '/companies/:id/companyImagesDelete' => 'companies#companyImagesDelete', via: [:delete], :as => :companyImagesDelete

  match '/products/:id/productImagesUpload' => 'products#productImagesUpload', via: [:post], :as => :productImagesUpload
  match '/products/:id/productImagesDelete' => 'products#productImagesDelete', via: [:delete], :as => :productImagesDelete


 
  resources :companies
  resources :users
   
  root to: "main#index" 
end
