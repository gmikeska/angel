Rails.application.routes.draw do

  resources :pages do
    resources :designs
  end
  resources :designs
  get "/users/table",to: 'users#table', as: "users_table"
  resources :users
  resources :articles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
