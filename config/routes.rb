Rails.application.routes.draw do
  namespace :admin do
    post "import_sources/preview", to: "import_sources#preview"
    post "import_sources/:id/sync", to: "import_sources#sync", as: "import_source_sync"
    resources :import_sources
    resources :schools
    resources :teams do
      resources :players
      resources :events
    end
  end
  devise_for :admins

  as :admin do
    get "admins/edit", to: "devise/registrations#edit", as: :edit_admin_registration
    put "admins", to: "devise/registrations#update", as: :admin_registration
    get "admin/schools", as: :admin_root
  end

  namespace :api do
    namespace :v1 do
      resources :devices
      get "schools/:id/upcoming_events", to: "schools#upcoming_events"
      get "schools/:id/recent_results", to: "schools#recent_results"
      get "schools/snap-671/teams.json", to: redirect("/api/v1/schools/snap2-671/teams.json")
      get "schools/snap-678/teams.json", to: redirect("/api/v1/schools/snap2-678/teams.json")
      get "schools/snap-792/teams.json", to: redirect("/api/v1/schools/snap2-792/teams.json")
      get "schools/snap-1182/teams.json", to: redirect("/api/v1/schools/snap2-1182/teams.json")
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
  get "support/", to: "home#support", as: :support
  get "privacy-policy/", to: "home#privacy_policy", as: :privacy_policy
  get "terms/", to: "home#terms", as: :terms
  root "home#index"
end
