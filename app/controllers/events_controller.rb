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

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_data)

    render plain: result.to_json
  end

  def create_web

    originating_data = { url: params[:url] }

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_data)

    render plain: result.to_json
  end

end
