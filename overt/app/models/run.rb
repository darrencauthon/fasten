class Run < ApplicationRecord

  def self.start event, step, workflow

    return if step.nil?

    run_id = generate_a_run_id_for step, event

    run = Run.where(id: run_id).first || Run.new

    run.id = run_id
    run.workflow_id = workflow.id

    run.save

    event.message = Mashing.mash_single_value step[:message], event.data
    event.run_id = run.id
    event.workflow_id = workflow.id

    execute_step step, event, workflow

    run

  end

  class << self

    def generate_a_run_id_for step, event
      run_id = SecureRandom.uuid
      if step[:config] && step[:config][:run_id] && step[:config][:run_id] != ''
        computed_run_id = Mashing.mash_single_value step[:config][:run_id], event.data
        if computed_run_id && computed_run_id.strip != ''
          run_id = computed_run_id.strip
        end
      end
      run_id
    end

    def execute_step step, event, workflow
      events = step[:method].call event

      events.each { |e| e.step_id = step[:id] || step[:config][:id] }

      events.each { |e| Event.persist e, event }

      next_steps = workflow.steps
                     .select { |x| x[:parent_step_ids] }
                     .select { |x| x[:parent_step_ids].include? step[:id] }

      next_steps.each do |next_step|
        events.each { |e| run_this_step next_step, e, workflow }
      end

    end

    def run_this_step step, event, workflow
      RunAStepWorker.set(queue: :single).perform_async step[:id], event.id, workflow.id
    end

  end

end
