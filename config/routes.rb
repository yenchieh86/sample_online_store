Rails.application.routes.draw do

  get 'user/show/:id', to: 'users#show', as: 'user_show'
  get 'user/list', to: 'users#list', as: 'user_list'
  devise_for :users
  resources 'categories'
  root 'static_page#home'
end
