Rails.application.routes.draw do
  resources :parking_spots, only: [:create, :index]
end
