class Workflow

  attr_accessor :steps

  def self.build(definition)
    workflow = Workflow.new

    workflow.steps = definition[:steps]
    workflow.steps
      .each_with_index { |x, i| x[:next_step] = workflow.steps[i+1] }
      .each_with_index do |step, i|
	 if i == 0
	   step[:method] = lambda { |e| step[:type].constantize.new.fire e }
	 else
	   step[:method] = lambda { |e| step[:type].constantize.new.receive e }
	 end
      end

    workflow
  end

  def start(data)

    last_event = data

    return if steps.empty?

    execute_step steps.first, last_event

  end

  private

  def execute_step(step, event)

    next_event = handle step[:method], event

    return if step[:next_step].nil?

    execute_step step[:next_step], next_event

  end

  def handle(method, last_event)

    events = [method.call(last_event)].flatten

    events.each { |x| persist x, last_event }

    events.first

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
