require_relative '../models/event_classes.rb'

class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    washington = Washington.new params[:message]
    washington.publish

    truman = Truman.new "event ##{washington.event_id} was fired"
    truman.subscribe_to washington
    truman.publish

    nixon = Nixon.new "event ##{truman.event_id} was fired"
    nixon.subscribe_to truman
    nixon.publish

    clinton = Clinton.new "event ##{nixon.event_id} was fired"
    clinton.subscribe_to nixon
    clinton.publish

    render plain: washington.to_json
  end
end