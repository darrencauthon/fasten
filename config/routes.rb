require 'sidekiq/web'
Rails.application.routes.draw do
  get 'sequence/new'
  get 'events/index'
  get 'events/all'
  post 'events/create'
  get 'events/create'

  post 'events/create_web'
  get 'events/create_web'

  post 'events/create_with_tree'
  get 'events/create_with_tree'

  mount Sidekiq::Web => '/sidekiq'
end
