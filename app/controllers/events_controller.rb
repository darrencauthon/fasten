require_relative '../models/event_handler.rb'
require_relative '../models/subscription.rb'
require_relative '../models/subscription_handler.rb'

class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = Apple.new.fire({ message: params[:message] })
    publish event

    subscription_data = Subscription.new
    subscription_data.message = "event ##{event.id} was fired"
    subscription_data.prior_event = event
    subscription_data.event_handler_type = Orange

    event = SubscriptionHandler.new.receive subscription_data
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
