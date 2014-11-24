Watchio::Application.routes.draw do
  root "movies#index"
  resources :movies, only: [:index, :create, :update, :destroy]
  resources :users

  get "/login", to: "session#new"
  post "/session", to: "session#create"
  delete "/session", to: "session#destroy"

  post "/movies/api", to: "movies#api"
end
