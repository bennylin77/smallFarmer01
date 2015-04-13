Rails.application.routes.draw do
  

  get  'main/index'  
    

  
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
 
  resources :companies
  resources :users
   
  root to: "main#index" 
end
