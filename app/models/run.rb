class Run < ApplicationRecord

  def self.start event, step, workflow

    return if step.nil?

    run = Run.new
    run.id = SecureRandom.uuid
    run.save

    event.message = Mashing.mash_single_value step[:message], event.data
    event.run_id = run.id
    event.workflow_id = workflow.id

    execute_step step, event, workflow

    run

  end

  class << self

    private

    def execute_step step, event_data, workflow
      events = step[:method].call event_data

      events.each { |e| e.step_id = step[:id] || step[:config][:id] }

      events.each { |e| Event.persist e, event_data }

      next_steps = workflow.steps
                     .select { |x| x[:parent_step_ids] }
                     .select { |x| x[:parent_step_ids].contains(step[:id]) }

      next_steps.each do |next_step|
        events.each { |e| execute_step next_step, e }
      end

    end

  end

end
