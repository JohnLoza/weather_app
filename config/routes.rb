Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pronostics#index'

  namespace :api do
    namespace :v1 do
      get 'pronostics/search', as: :pronostics_search
    end
  end
end
