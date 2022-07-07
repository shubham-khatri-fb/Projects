Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource :user_transactions do
    collection do
      post 'make_transaction'
      post 'deposit_money'
      post 'withdrawal_money'
      post 'change_currency'
      get 'all_transaction'
      get 'download_excel'

    end
  end

  resource :users do 
    collection do
      get 'login'
      post 'upload_image'
      get 'show_image'
    end
  end
  resources :users

end
