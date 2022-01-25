Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :schools do
        resources :teams do
          resources :pressbox_posts
          resources :events
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
