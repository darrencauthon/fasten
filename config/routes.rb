require 'sidekiq/web'
Rails.application.routes.draw do
  get 'sequence/new'
  get 'events/index'
  get 'events/all'
  get 'events/aggregate'
  post 'events/create'
  get 'events/create'
  get 'events/demo'

  post 'events/create_web'
  get 'events/create_web'

  post 'events/create_with_tree'
  get 'events/create_with_tree'

  post 'events/import_definition'

  post 'events/load_workflow_and_run'

  get 'step_editor/index'

  mount Sidekiq::Web => '/sidekiq'
end
