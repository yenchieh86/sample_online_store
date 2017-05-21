Rails.application.routes.draw do

  get 'shipping_fees/show', to: 'shipping_fees#show', as: 'check_shipping_fee'

  get 'user/show/:id', to: 'users#show', as: 'user_show'
  get 'user/list', to: 'users#list', as: 'user_list'
  delete 'user/erase/:id', to: 'users#erase', as: 'erase_user'
  
  devise_for :users, controllers: { registrations: 'users/registrations' }
  
  resources 'users', only: [] do
    resources 'orders', only: [:index]
  end
  
  resources 'categories' do
    resources 'items', only: [:show]
  end
  
  resources 'items', only: [:new, :create, :edit, :update, :destroy] do
    resources 'order_items', only: [:create]
  end
  
  resources 'orders', only: [:show] do
    resources 'shipping_informations', only: [:show, :new, :create, :edit, :update]
    resources 'charges', only: [:new, :create]
    resources 'tracking_numbers'
  end
  
  resources 'order_items', only: [:update, :destroy]
  
  root 'static_page#home'
end
