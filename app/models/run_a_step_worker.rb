class RunAStepWorker
  include Sidekiq::Worker

  def perform a, b, c
    raise [a, b, c].inspect
  end
end
