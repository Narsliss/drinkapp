Rails.application.routes.draw do
  get 'notes/create'
  get 'notes/update'
  get 'ratings/create'
  root 'recipes#index'

  resources :recipes, only: %i[index show] do
    resources :ratings, only: [:create]
    resources :notes, only: %i[create update]
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
