class CronEventWorker

  include Sidekiq::Worker

  def perform workflow_id, step_id
    raise [workflow_id, step_id].inspect
  end

end
