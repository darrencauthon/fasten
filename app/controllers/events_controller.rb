class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    first_event = create_event params[:message]
    publish first_event

    second_event = create_event "event ##{first_event.id} was fired", first_event
    publish second_event

    third_event = create_event "event ##{second_event.id} was fired", second_event
    publish third_event

    fourth_event = create_event "event ##{third_event.id} was fired", third_event
    publish fourth_event

    render plain: first_event.to_json
  end

  private

  def create_event(message, prior_event=nil)
    event = Event.new message: message
    link_event_to(event, prior_event) if prior_event

    event.save
    event
  end

  def link_event_to(event, prior_event)
    event.prior_event_id = prior_event.id
  end

  def publish(event)
    channels_client = Pusher::Client.new(app_id: 'fasten', key: 'app_key', secret: 'secret', host: 'poxa', port: 8080)
    channels_client.trigger('channel', 'event', message: event.message, prior_event_id: event.prior_event_id, id: event.id);
  end
end
