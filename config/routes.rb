Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :devices
      get 'schools/:id/upcoming_events', to: 'schools#upcoming_events'
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
  get 'support/', to: 'home#support', as: :support
  get 'privacy-policy/', to: 'home#privacy_policy', as: :privacy_policy
  get 'terms/', to: 'home#terms', as: :terms
  root 'home#index'
end
