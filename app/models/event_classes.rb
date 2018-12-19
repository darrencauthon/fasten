class Washington
  def initialize(message)
    @event = self.create_event message
  end

  def event_id
    @event.id
  end

  def publish
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: @event.message, prior_event_id: @event.prior_event_id, id: @event.id);
  end

  def create_event(message)
    event = Event.new message: message

    event.save
    event
  end

  def to_json
    @event.to_json
  end
end


class Truman
  def initialize(message)
    @event = self.create_event message
  end

  def event_id
    @event.id
  end

  def publish
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: @event.message, prior_event_id: @event.prior_event_id, id: @event.id);
  end

  def subscribe_to washington
    @event.prior_event_id = washington.event_id
    @event.save
  end

  def create_event(message)
    event = Event.new message: message

    event.save
    event
  end
end

class Nixon
  def initialize(message)
    @event = self.create_event message
  end

  def event_id
    @event.id
  end

  def publish
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: @event.message, prior_event_id: @event.prior_event_id, id: @event.id);
  end

  def subscribe_to truman
    @event.prior_event_id = truman.event_id
    @event.save
  end

  def create_event(message)
    event = Event.new message: message

    event.save
    event
  end
end

class Clinton
  def initialize(message)
    @event = self.create_event message
  end

  def publish
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: @event.message, prior_event_id: @event.prior_event_id, id: @event.id);
  end

  def subscribe_to nixon
    @event.prior_event_id = nixon.event_id
    @event.save
  end

  def create_event(message)
    event = Event.new message: message

    event.save
    event
  end
end