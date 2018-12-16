class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = create_event params[:message]
    publish event

    render plain: event.to_json
  end

  def create_event(message)
    Event.create message: params[:message]
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: event.message);
  end
end
