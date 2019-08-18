class Workflow

  attr_accessor :id
  attr_accessor :steps
  attr_accessor :context

  def initialize
    self.context = SymbolizedHash.new
    self.steps = []
  end

  def self.all
    files = Dir["/workflows/*.json"]
      .map do |x|
	content = ''
        File.open(x) do |f|
	  f.each_line { |l| content = content + l }
	end
        JSON.parse content, symbolize_names: true
      end
      .map do |x|
        Workflow.build x
      end
  end

  def self.build(definition)
    workflow = Workflow.new

    workflow.id = 'nope'

    workflow.steps = definition[:steps]

    workflow.steps.each do |step|
      set_up_the_method step, workflow
    end

    workflow
  end

  def self.set_up_the_method(step, workflow)

    step[:method] = lambda do |event|
      event_handler = Workflow.build_event_handler_for step, workflow

      event_handler.config = Mashing.mash(event_handler.config, event.data)

      events = [event_handler.receive(event)].flatten

      events = events.select { |x| x.is_a? Event }

      if (event_handler.config[:merge_mode] == 'merge')
        copy_event_data_from event, events
      end

      events
        .reject { |x| x.message }
        .each   { |e| e.message = Mashing.mash_single_value(event_handler.config[:message], e.data) }

      events
        .select { |x| x.message.to_s == '' }
        .each   { |e| e.message = "Event #{e.id}" }

      events

    end

    step[:config] = SymbolizedHash.new if step[:config].nil?

    return if step[:next_steps].nil?

    step[:next_steps].each { |x| set_up_the_method(x, workflow) }

  end

  def self.build_event_handler_for(step, workflow)
    event_handler = step[:type].constantize.new
    event_handler.config = SymbolizedHash.new(step[:config]) if event_handler.respond_to?(:config)
    event_handler.workflow = workflow if event_handler.respond_to?(:workflow)
    event_handler
  end

  private

  def self.copy_event_data_from source_event, target_events
    target_events.each do |target_event|
      target_event.data = Hash.new unless target_event.data
      source_event.data.keys
        .reject { |k| target_event.data.keys.include? k }
        .each   { |k| target_event.data[k] = source_event.data[k] }
    end
  end

end
