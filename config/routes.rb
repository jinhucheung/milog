Rails.application.routes.draw do

  root 'home#index'

  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'

  resources :users, except: [:new, :create] ,constraints: { id: User::USERNAME_FORMAT }
end
