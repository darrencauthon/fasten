class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    event = Event.create message: 'the event of a lifetime.'
    render plain: event.to_json
  end
end
