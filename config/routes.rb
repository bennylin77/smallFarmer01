Rails.application.routes.draw do
  
  post 'users/mobileSMSConfirmationSend'
  get  'main/index'  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks',
                                       registrations: "registrations" }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/:id/mobileSMSConfirmation' => 'users#mobileSMSConfirmation', via: [:get, :patch], :as => :mobileSMSConfirmation

 
  resources :companies
  resources :users
   
  root to: "main#index" 
end
