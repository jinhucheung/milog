Rails.application.routes.draw do

  root 'home#index'
  
  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  namespace :api do 
    scope :accounts, as: 'accounts' , constraints: { id: User::USERNAME_FORMAT } do
      get '/:id/active' => 'accounts#active', as: 'active'
      get '/:id/sendactivemail' => 'accounts#send_active_mail', as: 'send_active_mail'
    end
  end

  # 用户操作路由应该放在最后
  resources :users, except: [:new, :create] , path: "" , constraints: { id: User::USERNAME_FORMAT }
end
