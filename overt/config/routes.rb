require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do

  get 'overt', to: 'overt#home'
  get 'overt/workflows', to: 'overt#workflows'
  get 'overt/workflows/view/:id', to: 'overt#workflow'
  get 'overt/workflows/view-step/:workflow_id/:id', to: 'overt#view_step'
  get 'overt/workflows/step-json/:workflow_id/:id', to: 'overt#step_json'
  get 'overt/workflows/build-step/:workflow_id', to: 'overt#build_step'
  get 'overt/workflows/build-workflow', to: 'overt#build_workflow'

  get 'overt/manual-starts', to: 'overt#manual_starts'
  get 'overt/manual-starts/view/:workflow_id/:step_id', to: 'overt#view_manual_start'
  get 'overt/manual-starts/json/:workflow_id/:step_id', to: 'overt#manual_start_json'

  get 'overt/records', to: 'overt#records'
  get 'overt/records/view/:id', to: 'overt#view_record'
  get 'overt/records/view_collection/:collection', to: 'overt#records'

  get 'overt/runs/view/:id', to: 'overt#view_run'

  post 'overt/workflows/create-workflow', to: 'overt#create_workflow'
  post 'overt/workflows/save-workflow', to: 'overt#save_workflow'
  post 'overt/workflows/create-step/:workflow_id', to: 'overt#create_a_new_step'
  post 'overt/workflows/save-step/:id', to: 'overt#save_step'
  post 'overt/workflows/save-test-event/:id', to: 'overt#save_test_event'
  post 'overt/workflows/delete-step/:id', to: 'overt#delete_step'

  #############################################

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
