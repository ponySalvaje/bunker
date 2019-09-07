Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      post 'user_token' => 'user_token#create'
      get 'users/current' => 'users#current'
      resources :users
      # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
      get 'document_types' => 'document_types#index'
      resources :document_types

      get 'devices' => 'devices#index'
      get 'devices/:id' => 'devices#show'
      post 'devices' => 'devices#create'
      patch 'devices/:id' => 'devices#update'
      delete 'devices/:id' => 'devices#destroy'
      resources :devices

      get 'services' => 'services#index'
      get 'services/:id' => 'services#show'
      post 'services' => 'services#create'
      delete 'services/:id' => 'services#destroy'
      resources :services
    end
  end
end