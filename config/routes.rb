Rails.application.routes.draw do
  get 'users/show/:id', to: 'users#show', as: 'user_show'

  devise_for :users
  root 'static_page#home'
end
