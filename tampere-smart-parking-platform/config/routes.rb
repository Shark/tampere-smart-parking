Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/admin')

  resources :parking_spots, only: [:create, :index] do
    collection do
      post :bulk_update
      patch :toggle_blocked
    end
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/map_data', to: 'dashboard#map_data'
  end

  post '/dialog_flow', to: 'dialog_flow#webhook'

  get '/.well-known/health_check', to: 'health#health_check'
end
