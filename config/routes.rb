Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'admin/sessions'
  }, path: 'admin', path_names: { sign_in: '/sign_in' }
  # devise_for :users, controllers: {
  #       sessions: "api/v1/sessions"
  #     }, path: "admin", path_names: { sign_in: "sign_in", sign_out: "sign_out" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest
  # Defines the root path route ("/")

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root to: 'home#index'
    namespace :admin do
      get '/', to: 'home#index'
      resources :users
      resources :clinics
      resources :appointments
      resources :doctors do
        get 'search', on: :collection
      end
      resources :patients do
        get 'search', on: :collection
        resources :health_records
      end
    end
  end
  namespace :api do
    namespace :v1 do
      resources :users
      get '/patients', to: 'patients#index'
    end
  end
end
