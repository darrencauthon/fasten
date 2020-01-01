class RunAStepWorker
  include Sidekiq::Worker

  def perform step_id, parent_event_id, workflow_id

    workflow = Workflow.find workflow_id
    step = workflow.steps.select { |x| x[:id] == step_id }.first
    parent_event = Event.find parent_event_id

    Run.execute_step step, parent_event, workflow

  end

end
