require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do

  get 'events', to: 'events#new_index'
  get 'workflows', to: 'workflows#index'
  get 'workflows/json/:id', to: 'workflows#json'
  post 'workflows/json/:id', to: 'workflows#save'
  get 'workflows/edit/:id', to: 'workflows#edit'
  get 'workflows/step_types', to: 'workflows#step_types'

  get 'starter', to: 'starter#index'
  get 'starter/step', to: 'starter#step'
  post 'starter/run_step', to: 'starter#run_step'

  get '', to: 'home#index'
  get 'runs', to: 'runs#index'
  get 'runs/view/:id', to: 'runs#view'

  get 'records', to: 'crud#index'
  get 'records/view/:id', to: 'crud#view'
  get 'records/json/:id', to: 'crud#json'
  post 'records/delete', to: 'crud#delete'

  get 'sequence/new'
  get 'events/index'
  get 'events/all'
  get 'events/single/:id', to: 'events#single'
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

  get 'workflow_editor_data/:id', to: "workflow_editor#data"
  get 'workflow_editor/:id', to: "workflow_editor#index"
  post 'workflow_editor/:id', to: "workflow_editor#save"

  get 'cron_events', to: 'cron_events#index'

  get 'web_endpoints', to: 'web_endpoints#index'

  get 'manual_starts', to: 'manual_starts#index'
  get 'manual_starts/view/:workflow_id/:step_id', to: 'manual_starts#view'
  get 'manual_starts/fire/:workflow_id/:step_id', to: 'manual_starts#fire'
  post 'manual_starts/fire/:workflow_id/:step_id', to: 'manual_starts#fire'

  mount Sidekiq::Web => '/sidekiq'

  match '*path', to: 'web_endpoints#fire', via: :all

end
