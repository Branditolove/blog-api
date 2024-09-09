Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]
  
  namespace :api do
    devise_scope :user do
      post 'sign_up', to: 'registrations#create'
      post 'sign_in', to: 'sessions#create'
      delete 'sign_out', to: 'sessions#destroy'
    end
    
    resources :posts
  end
end