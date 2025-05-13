Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post :signup, to: 'users#create'
      post :login, to: 'sessions#create'

      resources :questions, only: %i[index show create update destroy] do
        resources :comments
        resources :answers, only: %i[index show create update destroy] do
          resources :comments
        end
      end
    end
  end
end
