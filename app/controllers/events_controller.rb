class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = broadcast params[:message]
    broadcast "event ##{event.id} was fired"
    render plain: event.to_json
  end
  
  private

  def create_event(message)
    Event.create message: message
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: event.message);
  end

  def broadcast(message)
    event = create_event message
    publish event

    event
  end
end
