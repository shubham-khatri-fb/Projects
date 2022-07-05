Rails.application.routes.draw do
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'make_transaction', to: 'user_transactions#make_transaction'
  post 'deposit_money', to: 'user_transactions#deposit_money'
  post 'withdrawal_money', to: 'user_transactions#withdrawal_money'
  post 'change_currency', to: 'user_transactions#change_currency'
  get 'all_transaction', to: 'user_transactions#all_transaction'
  post 'create_two_fa', to: 'users#create_two_fa'
  post 'send_otp_two_fa', to: 'users#send_otp_two_fa'
  get 'verify_two_fa', to: 'users#verify_two_fa'
  get 'logout', to: 'users#logout'
  get 'login', to: 'users#login'
  get 'download_transaction_h', to: 'user_transactions#download_excel'
  #patch 'deposit_money', to: 'user_transactions#deposit_money'
  post 'upload_image', to: 'users#upload_image'
  get 'show_image', to: 'users#show_image'
end
