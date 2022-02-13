Rails.application.routes.draw do
  get 'withdraw/account'
  resources :account_histories
  resources :accounts
  devise_for :users

  get '/accounts/:id/user', to: 'accounts#user_accounts', as: 'user_accounts'
  get '/accounts/:number/withdraw', to: 'accounts#withdraw', as: 'withdraw'
  get '/accounts/:number/transference', to: 'accounts#transference', as: 'transference'
  

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
