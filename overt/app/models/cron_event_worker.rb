class CronEventWorker

  include Sidekiq::Worker

  def perform workflow_id, step_id
    workflow = Workflow.find workflow_id
    step = workflow.steps.select { |x| x[:id] == step_id }.first

    originating_event = Event.new(data: step[:config] || {})

    run = Run.start originating_event, step, workflow
  end

end
