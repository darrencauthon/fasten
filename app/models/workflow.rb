class Workflow

  attr_accessor :steps

  def self.build(definition)
    workflow = Workflow.new
    workflow.steps = definition[:steps]
    workflow
  end

  def start(data)

    steps.each_with_index { |x, i| x[:method] = (i == 0 ? :fire : :receive) }

    steps.reduce(data) do |last_event, step_data|
      event = step_data[:type].constantize.new.send(step_data[:method], last_event)

      event.prior_event_id = last_event.id if last_event.is_a?(Event)
      event.data = event.data || {}
      event.save
      
      publish event
      
      event
    end
  end

  private

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    data = { message: event.message, prior_event_id: event.prior_event_id, id: event.id }
    channels_client.trigger('channel', 'event', data);
  end

end
