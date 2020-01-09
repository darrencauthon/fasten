class CronEvent

  attr_accessor :config

  def receive event
    event.data
  end

  def self.setup_all

    Sidekiq::Cron::Job.destroy_all!

    Workflow.all.each do |workflow|

      workflow.steps.select { |x| x[:type] == 'CronEvent' }.each do |step|
        Sidekiq::Cron::Job.create(name:  "#{workflow.id}_#{step[:id]}",
                                  cron:  step[:config][:cron],
                                  class: 'CronEventWorker', args: [workflow.id, step[:id]])
      end

    end

  end

end
