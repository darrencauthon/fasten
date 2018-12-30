class Workflow

  attr_accessor :first_step

  def self.build(definition)
    workflow = Workflow.new

    steps = definition[:steps]
    steps
      .each_with_index { |x, i| x[:next_step] = steps[i+1] }
      .each_with_index { |x, i| x[:method] = lambda { |e| x[:type].constantize.new.receive e } }

    workflow.first_step = steps.first
    workflow.first_step[:method] = lambda { |e| workflow.first_step[:type].constantize.new.fire e }

    workflow
  end

  def start(data)

    return if first_step.nil?

    execute_step first_step, data

  end

  private

  def execute_step(step, event)

    events = [step[:method].call(event)].flatten

    events.each { |e| persist e, event }

    return if step[:next_step].nil?

    events.each { |e| execute_step step[:next_step], e }

  end

  def persist(event, last_event)
    event.prior_event_id = last_event.id if last_event.is_a?(Event)
    event.data = event.data || {}
    event.save
      
    publish event
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    data = { message: event.message, prior_event_id: event.prior_event_id, id: event.id }
    channels_client.trigger('channel', 'event', data);
  end

end
