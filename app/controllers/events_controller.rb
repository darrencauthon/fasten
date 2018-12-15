class EventsController < ApplicationController
  def index
  end

  def all
    render :json => Event.all
  end
end
