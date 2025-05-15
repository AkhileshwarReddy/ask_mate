Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      concern :votable do
        post :upvote, on: :member, to: 'votes#upvote'
        post :downvote, on: :member, to: 'votes#downvote'
      end

      post :signup, to: 'users#create'
      post :login, to: 'sessions#create'

      resources :questions, params: :question_id, only: %i[index show create update destroy], concerns: :votable do
        resources :comments, params: :comment_id, only: %i[index show create update destroy], concerns: :votable
        resources :answers, params: :answer_id, only: %i[index show create update destroy] , concerns: :votable do
          resources :comments, params: :comment_id, only: %i[index show create update destroy], concerns: :votable
        end
      end
    end
  end
end
