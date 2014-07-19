Watchio::Application.routes.draw do
  root "movies#index"
  resources :movies, only: [:index, :create, :update, :destroy]

  post "/movies/api", to: "movies#api"
end
