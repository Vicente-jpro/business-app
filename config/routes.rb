Rails.application.routes.draw do
  resources :account_histories
  resources :accounts
  devise_for :users

  get '/accounts/:id/user_accounts', to: 'accounts#user_accounts', as: 'user_accounts'


  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
