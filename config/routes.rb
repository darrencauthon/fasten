require 'sidekiq/web'
Rails.application.routes.draw do
  get 'sequence/new'
  get 'events/index'
  get 'events/all'
  post 'events/create'
  get 'events/create'
  mount Sidekiq::Web => '/sidekiq'
end
