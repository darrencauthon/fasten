class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = EventHandler.new.fire({ message: params[:message] })
    publish event

    things = [{ name: 'Orange', type: EventHandler },
              { name: 'Banana', type: EventHandler },
              { name: 'Pear',   type: EventHandler }]

    things.each do |thing|
      event = thing[:type].new.receive event
      publish event
    end

    render plain: event.to_json
  end

  private

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    data = { message: event.message, prior_event_id: event.prior_event_id, id: event.id }
    channels_client.trigger('channel', 'event', data);
  end
end
