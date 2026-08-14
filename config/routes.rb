Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "projects#index"

  resources :projects do
    # Nested so URLs read as /projects/1/tasks/3 — makes it clear that tasks belong to a project, and allows us to scope task creation to a specific project and never float alone.
    resources :tasks do
      # A dedicated route just for toggling completion — keeps the
      # "mark done" action separate from a full task update, which
      # matters because it's triggered by a single click, not a form
      member do
        patch :toggle
      end
    end

    resources :memberships, only: [:create, :destroy]
    end
end
