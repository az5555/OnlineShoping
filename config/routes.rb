Rails.application.routes.draw do
  resources :users, except: [:destroy, :show] do
    post :upload_image, on: :member
  end
  root 'home#index'
  resources :sessions, only: [:new, :create]
  delete '/logout' => 'sessions#destroy', as: :logout
  get '/userCenter' => 'users#show', as: :userCenter
  post 'editPassword' => 'users#editPassword', as: :editPassword
  resources :comments
  resources :categories, only: [:show]
  resources :requests, only: :create
  resources :products, only: [:show] do
    get :search, on: :collection
  end
  resources :shopping_carts, except: [:edit, :new]
  resources :collections, except: [:edit, :new, :update]
  resources :orders, except: [:show]
  namespace :admin do
    resources :comments, except: :show
    resources :categories, except: :show
    resources :users, only: [:index, :update]
    resources :requests, only: [:index, :update, :destroy]
    resources :products, except: :show do
      resources :product_images
    end
    resources :orders, except: :show
  end

  namespace :delivery do
    resources :orders, only: [:update, :index] do
      get :my_order, on: :collection
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
