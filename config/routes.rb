Rails.application.routes.draw do

  root 'home#index'

  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  namespace :api do 
    get '/accounts/active' => 'accounts#active'
  end

  # 用户操作路由应该放在最后
  resources :users, except: [:new, :create] , path: "" , constraints: { id: User::USERNAME_FORMAT }
end
