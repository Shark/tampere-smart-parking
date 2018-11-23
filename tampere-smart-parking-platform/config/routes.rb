Rails.application.routes.draw do
  resources :parkingspot, only: [:create, :index]
end
