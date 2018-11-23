Rails.application.routes.draw do
  resources :parkingspots, only: [:create, :index]
end
