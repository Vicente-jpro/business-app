Rails.application.routes.draw do
  get 'bank_statement/index'

  root 'home#index'

  #post '/accounts/:number/transference_now', to: 'accounts#transference_now'
  get '/accounts/:number/change_account_status', to: 'accounts#change_account_status', as: 'change_account_status'
  
  resources :accounts do
    member do
      get 'user'
      get 'withdraw'
      get 'transference'
      post 'transference_now'

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
