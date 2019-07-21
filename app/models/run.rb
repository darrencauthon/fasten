class Run

  attr_accessor :id

  def self.start event, step

    return if step.nil?

    run = Run.new
    run.id = SecureRandom.uuid

    event.message = Mashing.mash_single_value step[:message], event.data
    event.run_id = run.id

    execute_step step, event

    run

  end

  class << self

    private

    def execute_step step, event_data
      events = step[:method].call event_data

      events.each { |e| e.step_id = step[:step_id] }

      events.each { |e| Event.persist e, event_data }

      return if step[:next_steps].nil?

      step[:next_steps].each do |next_step|
        events.each { |e| execute_step next_step, e }
      end

    end

  end

end
