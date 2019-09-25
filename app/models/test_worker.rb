class TestWorker

  include Sidekiq::Worker

  def perform name
  end

end
