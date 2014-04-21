Watchio::Application.routes.draw do
  root "movies#index"
  resources :movies, only: [:index, :create, :update, :destroy]
end
