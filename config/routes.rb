Rails.application.routes.draw do
  get 'bank_statement/index'

  root 'home#index'
  
  #devise_for :users, path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'} 
  #get '/accounts/:id/user', to: 'accounts#user_accounts', as: 'user_accounts'
  #get '/accounts/:number/withdraw', to: 'accounts#withdraw', as: 'withdraw'
  #get '/accounts/:number/transference', to: 'accounts#transference', as: 'transference'
  post '/accounts/:number/transference_now', to: 'accounts#transference_now'
  get '/accounts/:number/change_account_status', to: 'accounts#change_account_status', as: 'change_account_status'
  
  resources :accounts do
    member do
      get 'user'
      get 'withdraw'
      get 'transference'
    end
  end
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
