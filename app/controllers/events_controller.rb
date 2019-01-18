class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create

    originating_event = Event.create(message: params[:message])

    steps = JSON.parse(request.body.read, symbolize_names: true)

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

  def create_web

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

  def create_with_tree

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build_given_a_hierarchy(first_step: { name: 'Apple', type: 'WebRequest', config: { url: 'http://google.com' }, next_steps: [{ name: 'Orange',  type: 'WebRequest', config: { url: 'http://bing.com' } }, { name: 'Banana',  type: 'WebRequest', config: { url: 'http://yahoo.com', thing: 'Status: {{status}}' } }] })

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

end
