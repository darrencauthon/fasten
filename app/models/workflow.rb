class Workflow

  attr_accessor :first_step

  def self.build(definition)
    workflow = Workflow.new

    definition[:steps]
      .each_with_index { |x, i| x[:next_steps] = [definition[:steps][i+1]].reject { |x| x.nil? } }

    workflow.first_step = definition[:steps].first

    set_up_the_method workflow.first_step

    workflow
  end

  def self.build_given_a_hierarchy(definition)
    workflow = Workflow.new

    workflow.first_step = definition[:first_step]

    set_up_the_method workflow.first_step

    workflow
  end

  def self.mash(config, event)
    config
      .select { |_, y| y.is_a? String }
      .each do |key, value|
	template = Liquid::Template.parse value
        config[key] = template.render SymbolizedHash.new(event.data)
      end

    config
  end

  def self.set_up_the_method(step)

    step[:method] = lambda do |e|
      event_handler = Workflow.build_event_handler_for step

      event_handler.config = mash(event_handler.config, e)

      event_handler.receive e
    end

    step[:config] = {} if step[:config].nil?

    return if step[:next_steps].nil?

    step[:next_steps].each { |x| set_up_the_method(x) }

  end

  def self.build_event_handler_for(step)
    event_handler = step[:type].constantize.new
    event_handler.config = SymbolizedHash.new(step[:config]) if event_handler.respond_to?(:config)
    event_handler
  end

  def start(event)

    return if first_step.nil?

    execute_step first_step, event

  end

  private

  def execute_step(step, event_data)
    events = [step[:method].call(event_data)].flatten
    events.each { |e| e.step_guid = step[:guid] }

    events.each { |e| persist e, event_data }

    return if step[:next_steps].nil?

    step[:next_steps].each do |next_step|
      events.each { |e| execute_step next_step, e }
    end

  end

  def persist(event, last_event)
    event.prior_event_id = last_event.id if last_event.is_a?(Event)
    event.data = event.data || {}
    event.save

    publish event
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    data = { message: event.message, prior_event_id: event.prior_event_id, id: event.id, step_guid: event.step_guid }
    channels_client.trigger('channel', 'event', data);
  end

end
