Rails.application.routes.draw do
  mount_devise_token_auth_for 'Terminal', at: 'terminal_auth', controllers: { sessions: 'api/v1/sessions' }
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => '/cable'
  
  scope module: 'api' do
    namespace :v1 do
      
      resources :entries do
        resources :comments
      end

      resources :comments
      resources :quarters do
        resources :comments
        resources :locations
        resources :tasks
      end
      resources :locations do
        resources :comments
        resources :tasks
      end
      resources :tasks do
        resources :comments
      end
    end
  end
  root to: 'api/v1/api#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
