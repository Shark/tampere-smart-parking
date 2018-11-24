Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :parking_spots, only: [:create, :index]
  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/map_data', to: 'dashboard#map_data'
    #resources :dashboard, only: [:index]
  end
  patch '/toggle_parking_spots', to: 'parking_spots#toggle_spots'
  post '/dialog_flow', to: 'dialog_flow#webhook'

  get '/.well-known/health_check', to: 'health#health_check'
end
