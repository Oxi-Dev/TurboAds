Rails.application.routes.draw do

    devise_for :users, :controllers => {:registrations => "registrations"}
        
    resources :sessions, :only => [:new, :create, :destroy]
    
    devise_scope :user do
        get 'login', to: 'devise/sessions#new'
    end
    
    devise_scope :user do
        get 'signup', to: 'devise/registrations#new'
    end
    
    devise_scope :user do 
        root to: 'pages#index'
        match '/sessions/user', to: 'devise/sessions#create', via: :post
      end
    
    resources :posts do
      collection do
        get 'hobby'
        get 'study'
        get 'team'
      end
    end
    
    namespace :private do 
      resources :conversations, only: [:create] do
        member do
          post :close
          post :open
        end
      end
      resources :messages, only: [:index, :create]
    end

    root to: 'pages#index'
    
    # Serve websocket cable requests in-process
    mount ActionCable.server => '/cable'
end

