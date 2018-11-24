Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :parking_spots, only: [:create, :index]

  post '/dialog_flow', to: 'dialog_flow#webhook'

  get '/.well-known/health_check', to: 'health#health_check'
end
