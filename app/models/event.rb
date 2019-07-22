class Event < ApplicationRecord

  serialize :data, JSON

  after_initialize do |x|
    x.id ||= SecureRandom.uuid
    x.data ||= HashWithIndifferentAccess.new
  end

  def self.persist event, last_event
    event.parent_event_id = last_event.id
    event.data = event.data || {}
    event.run_id = last_event.run_id
    event.save

    publish event
  end

  class << self

    private

    def publish event
      channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
      data = { message: event.message, parent_event_id: event.parent_event_id, id: event.id, step_id: event.step_id }
      channels_client.trigger('channel', 'event', data);
    end

  end

end
