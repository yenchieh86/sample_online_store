Rails.application.routes.draw do

  get 'user/show/:id', to: 'users#show', as: 'user_show'
  get 'user/list', to: 'users#list', as: 'user_list'
  delete 'user/erase/:id', to: 'users#erase', as: 'erase_user'
  
  devise_for :users
  resources 'categories' do
    resources 'items'
  end
  root 'static_page#home'
end
