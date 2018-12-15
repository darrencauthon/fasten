require 'sidekiq/web'
Rails.application.routes.draw do
  get 'events/index'
  get 'events/all'
  mount Sidekiq::Web => '/sidekiq'
end

