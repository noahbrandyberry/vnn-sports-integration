Rails.application.routes.draw do
  namespace :admin do
    post 'import_sources/preview', to: 'import_sources#preview'
    resources :import_sources
    resources :schools
    resources :teams
  end
  devise_for :admins

  as :admin do
    get 'admins/edit', to: 'devise/registrations#edit', as: :edit_admin_registration
    put 'admins', to: 'devise/registrations#update', as: :admin_registration
    get 'admin/schools', as: :admin_root
  end

  namespace :api do
    namespace :v1 do
      resources :devices
      get 'schools/:id/upcoming_events', to: 'schools#upcoming_events'
      get 'schools/:id/recent_results', to: 'schools#recent_results'
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
