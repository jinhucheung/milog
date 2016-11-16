Rails.application.routes.draw do

  root 'home#index'
  
  get '/signup' => 'accounts#new'
  post '/signup' => 'accounts#create'

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  delete '/signout' => 'sessions#destroy'

  namespace :accounts, as: 'accounts', constraints: { id: User::USERNAME_FORMAT } do
    get '/passwords/forgot' => 'passwords#new'
    post '/passwords/forgot' => 'passwords#create'

    resources :passwords, only: [:edit, :update]
    resources :activations, only: [:new, :edit] 
  end
  
  resource :account, only: [:edit] do 
    patch '/edit', action: :update
    put '/edit', action: :update
  end

  constraints( id: /\d+/ ) do
    resources :articles
    resources :categories, only: [:create, :update, :destroy]
  end

  match '/pictures' => 'pictures#create', via: [:post, :patch, :put]

  # users相关路由最后
  resources :users, only: [:show] , path: '' , constraints: { id: User::USERNAME_FORMAT } do
    member do
      get :categories
      get :aboutme
      get :drafts
      get :archive
      get '/categories/:category_id', as: 'category', to: 'users#category'
      get '/tags/:tag_id', as: 'tag', to: 'users#tag'
    end
  end

end
