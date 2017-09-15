Rails.application.routes.draw do
  
  resources :change_password,			only: [:new, :create, :edit]

  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :orders, only: [:new, :create]

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users do
    get "/login" => "devise/sessions#new"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/pages/order_success", "pages#order_success"
  root "pages#home"
end
