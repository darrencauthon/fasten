class Workflow

  attr_accessor :steps
  attr_accessor :context

  def initialize
    self.context = SymbolizedHash.new
    self.steps = []
  end

  def self.build(definition)
    workflow = Workflow.new

    workflow.steps = definition[:steps]

    workflow.steps.each do |step|
      set_up_the_method step, workflow
    end

    workflow
  end

  def self.mash(config, event)

    fields_not_to_mash = ['message']

    config
      .select { |_, y| y.is_a? String }
      .reject { |x, _| fields_not_to_mash.include? x.to_s }
      .each do |key, value|
        config[key] = mash_single_value(value, event.data)
      end

    config
      .select { |_, y| y.is_a? Hash }
      .reject { |x, _| fields_not_to_mash.include? x.to_s }
      .each do |key, value|
        config[key] = mash_all(value, event)
      end

    config
  end

  def self.mash_all(config, event)
    config
      .select { |_, y| y.is_a? String }
      .each do |key, value|
        config[key] = mash_single_value(value, event.data)
      end

    config
      .select { |_, y| y.is_a? Hash }
      .each do |key, value|
        config[key] = mash_all(value, event)
      end

    config
  end

  def self.mash_single_value(value, data)
    Liquid::Template
      .parse(value)
      .render SymbolizedHash.new(data)
  end

  def self.set_up_the_method(step, workflow)

    step[:method] = lambda do |event|
      event_handler = Workflow.build_event_handler_for step, workflow

      event_handler.config = mash(event_handler.config, event)

      events = [event_handler.receive(event)]
                 .flatten
                 .select { |x| x.is_a? Event }

      if (event_handler.config[:merge_mode] == 'merge')
        copy_event_data_from event, events
      end

      events
        .reject { |x| x.message }
        .each   { |e| e.message = mash_single_value(event_handler.config[:message], e.data) }

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

  def start(event)

    return if steps[0].nil?

    execute_step steps[0], event

    result = WorkflowResult.new
    result.context = self.context
    result

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

  def execute_step(step, event_data)
    events = step[:method].call event_data

    events.each { |e| e.step_id = step[:step_id] }

    events.each { |e| persist e, event_data }

    return if step[:next_steps].nil?

    step[:next_steps].each do |next_step|
      events.each { |e| execute_step next_step, e }
    end

  end

  def persist(event, last_event)
    event.parent_event_id = last_event.id if last_event.is_a?(Event)
    event.data = event.data || {}
    event.run_id = last_event.run_id if last_event.is_a?(Event)
    event.save

    publish event
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    data = { message: event.message, parent_event_id: event.parent_event_id, id: event.id, step_id: event.step_id }
    channels_client.trigger('channel', 'event', data);
  end

end
