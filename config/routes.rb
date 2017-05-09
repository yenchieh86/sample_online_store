Rails.application.routes.draw do

  get 'user/show/:id', to: 'users#show', as: 'user_show'
  get 'user/list', to: 'users#list', as: 'user_list'
  delete 'user/erase/:id', to: 'users#erase', as: 'erase_user'
  
  resources 'items', only: [:index, :new, :create, :edit, :update, :destroy]
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources 'categories' do
    resources 'items', only: [:show]
  end
  root 'static_page#home'
end
