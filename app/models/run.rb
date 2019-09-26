class Run < ApplicationRecord

  def self.start event, step, workflow

    return if step.nil?

    run = Run.new

    if step[:config] && step[:config][:run_id] && step[:config][:run_id] != ''
      run.id = Mashing.mash_single_value step[:config][:run_id], event.data
    end
    run.id = run.id.strip
    if run.id == nil || run.id == ''
      run.id = SecureRandom.uuid unless run.id
    end

    run.workflow_id = workflow.id
    run.save

    event.message = Mashing.mash_single_value step[:message], event.data
    event.run_id = run.id
    event.workflow_id = workflow.id

    execute_step step, event, workflow

    run

  end

  class << self

    def execute_step step, event, workflow
      events = step[:method].call event

      events.each { |e| e.step_id = step[:id] || step[:config][:id] }

      events.each { |e| Event.persist e, event }

      next_steps = workflow.steps
                     .select { |x| x[:parent_step_ids] }
                     .select { |x| x[:parent_step_ids].include? step[:id] }

      next_steps.each do |next_step|
        events.each { |e| RunAStepWorker.perform_async next_step[:id], e.id, workflow.id }
      end

    end

  end

end
