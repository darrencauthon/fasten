class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create

    originating_data = { message: params[:message] }

    steps = [{ name: 'Apple',  type: 'EventHandler' },
             { name: 'Orange', type: 'EventHandler' },
             { name: 'Banana', type: 'EventHandler' },
             { name: 'Pear',   type: 'EventHandler' }]

    steps.each_with_index { |x, i| x[:method] = (i == 0 ? :fire : :receive) }

    event = steps.reduce(originating_data) do |k, i|
      e = i[:type].constantize.new.send(i[:method], k)

      e.prior_event_id = k.id if k.is_a?(Event)
      e.data = e.data || {}
      e.save
      e
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
