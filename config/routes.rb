require 'sidekiq/web'
Rails.application.routes.draw do
  get 'sequence/new'
  get 'events/index'
  get 'events/all'
  get 'events/aggregate'
  post 'events/create'
  get 'events/create'
  get 'events/demo'
  get 'events/read_a_file'

  post 'events/create_web'
  get 'events/create_web'

  post 'events/create_with_tree'
  get 'events/create_with_tree'

  post 'events/import_definition'

  mount Sidekiq::Web => '/sidekiq'
end
