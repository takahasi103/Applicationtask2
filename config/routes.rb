Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  devise_for :users
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  get "postsearch" => "searches#postsearch"
  get "bookstag" => "searches#tagsearch"
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end 
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end 
  resources :direct_messages, only: [:create]
  resources :rooms, only: [:create, :show]
  resources :groups do
    get "join" => "groups#join"
    get "new/mail" => "groups#new_mail"
    get "send/mail" => "groups#send_mail"
    delete "all_destroy" => "groups#all_destroy"
  end
  resources :tags do
    get 'books', to: 'books#search'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end