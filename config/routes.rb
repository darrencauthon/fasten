require 'sidekiq/web'
Rails.application.routes.draw do
  get 'events/index'
  get 'events/all'
  post 'events/create'
  get 'events/create'

  post 'events/create_web'
  get 'events/create_web'

  mount Sidekiq::Web => '/sidekiq'
end

