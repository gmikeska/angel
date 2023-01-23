Rails.application.routes.draw do
  resources :users
  resources :articles

  resources :pages do
    resources :designs
  end
  get "/pages/:page_id/designs/:id/component",to: 'designs#show_component', as: "page_design_component"
  get "/designs/:id/component",to: 'designs#show_component', as: "design_component"
  get "/designs/:id/component/edit",to: 'designs#component_settings', as: "design_component_settings"
  resources :designs
  get "/users/table",to: 'users#table', as: "users_table"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
