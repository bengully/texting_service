Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    get :messages, to: 'sms#index'
    post :send_message, to: 'sms#send_message'
    post :delivery_status, to: 'sms#delivery_status'
  end

  root 'home#index'
end
