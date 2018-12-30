class Workflow

  attr_accessor :steps

  def self.build(definition)
    workflow = Workflow.new

    workflow.steps = definition[:steps]
    workflow.steps
      .each_with_index { |x, i| x[:method] = (i == 0 ? :fire : :receive) }
      .each_with_index { |x, i| x[:next_step] = workflow.steps[i+1] }

    workflow
  end

  def start(data)

    last_event = data

    steps.each do |step|

      method = step[:method]
      event_handler = step[:type].constantize.new

      last_event = handle event_handler, method, last_event

    end

  end

  private

  def handle(step, method, event)

    last_event = event

    events = [step.send(method, event)].flatten

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
