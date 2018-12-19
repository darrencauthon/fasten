class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = Apple.new.fire {message: params[:message]}
    publish event
    
    event = Orange.new.receive event
    publish event
    
    event = Banana.new.receive event
    publish event
    
    event = Pear.new.receive event
    publish event

    render plain: event.to_json
  end

  private
  
  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: event.message, prior_event_id: event.prior_event_id, id: event.id);
  end
end
