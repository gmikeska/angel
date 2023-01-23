Rails.application.routes.draw do

  resources :pages do
    resources :designs do
      get "component", to:"designs#show_component", as:"page_design_component"
      get "component/edit", to:"designs#component_settings", as:"page_design_component_settings"
    end
  end
  resources :designs do
    get "component", to:"designs#show_component", as:"design_component"
    get "component/edit",to: 'designs#component_settings', as: "design_component_settings"
  end
  get "/users/table",to: 'users#table', as: "users_table"
  resources :users
  resources :articles
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
