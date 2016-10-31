Rails.application.routes.draw do
  root 'home#index'

  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  resources :users, except: [:new]
end
