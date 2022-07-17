Rails.application.routes.draw do
  get 'bank_statement/index'

  root 'home#index'

  resources :accounts do
    member do
      get 'user'
      get 'withdraw'
      get 'transference'
      post 'transference_now'
      get 'change_account_status'
    end
  end
  
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

end
