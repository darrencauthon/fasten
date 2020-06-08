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

  get 'overt/web-endpoints', to: 'overt#web_endpoints'
  get 'overt/web-endpoints/view/:workflow_id/:step_id', to: 'overt#view_web_endpoint'
  get 'overt/web-endpoints/json/:workflow_id/:step_id', to: 'overt#web_endpoint_json'

  get 'overt/crons', to: 'overt#crons'
  get 'overt/crons/view/:workflow_id/:step_id', to: 'overt#view_cron'
  get 'overt/crons/json/:workflow_id/:step_id', to: 'overt#cron_json'

  get 'overt/manual-starts', to: 'overt#manual_starts'
  get 'overt/manual-starts/view/:workflow_id/:step_id', to: 'overt#view_manual_start'
  get 'overt/manual-starts/json/:workflow_id/:step_id', to: 'overt#manual_start_json'
  post 'overt/manual-starts/fire/:workflow_id/:step_id', to: 'overt#manual_start_fire'

  get 'overt/records', to: 'overt#records'
  get 'overt/records/view/:id', to: 'overt#view_record'
  get 'overt/records/view_collection/:collection', to: 'overt#records'

  get 'overt/runs', to: 'overt#runs'
  get 'overt/runs/view/:id', to: 'overt#view_run'
  get 'overt/runs/json/:id', to: 'overt#run_json'
  get 'overt/runs/view_event/:id', to: 'overt#view_event'
  get 'overt/runs/event_json/:id', to: 'overt#event_json'
  post 'overt/run_step', to: 'overt#run_step'

  post 'overt/workflows/create-workflow', to: 'overt#create_workflow'
  post 'overt/workflows/save-workflow', to: 'overt#save_workflow'
  post 'overt/workflows/create-step/:workflow_id', to: 'overt#create_a_new_step'
  post 'overt/workflows/save-step/:id', to: 'overt#save_step'
  post 'overt/workflows/save-test-event/:id', to: 'overt#save_test_event'
  post 'overt/workflows/delete-step/:id', to: 'overt#delete_step'

  #############################################

  get 'workflows', to: 'workflows#index'
  get 'workflows/json/:id', to: 'workflows#json'
  post 'workflows/json/:id', to: 'workflows#save'
  get 'workflows/edit/:id', to: 'workflows#edit'
  get 'workflows/step_types', to: 'workflows#step_types'

  get 'starter', to: 'starter#index'
  get 'starter/step', to: 'starter#step'

  get '', to: 'home#index'
  get 'runs', to: 'runs#index'
  get 'runs/view/:id', to: 'runs#view'

  get 'sequence/new'

  get 'step_editor/index'

  get 'workflow_editor_data/:id', to: "workflow_editor#data"
  get 'workflow_editor/:id', to: "workflow_editor#index"
  post 'workflow_editor/:id', to: "workflow_editor#save"

  get 'web_endpoints', to: 'web_endpoints#index'

  mount Sidekiq::Web => '/sidekiq'

  match '*path', to: 'web_endpoints#fire', via: :all

end
