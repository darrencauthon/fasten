class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create
    originating_data = { message: params[:message] }
    steps_encoded = request.body.read
    steps = JSON.parse(steps_encoded, symbolize_names: true)

    workflow = Workflow.new
    workflow.name = steps[:first_step][:name]
    workflow.steps = steps_encoded
    workflow.save

    render plain: 'ok'
  end

  def fire
    workflow = Workflow.find_workflow params[:message]
    return render plain: "no workflow found for \"#{params[:message]}\"" unless workflow

    result = workflow.start({ message: params[:message] })

    render plain: result.to_json
  end

  def create_with_tree

    originating_data = { url: params[:url] }

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build(first_step: { name: 'Apple', type: 'WebRequest', config: { url: 'http://google.com' }, next_steps: [{ name: 'Orange',  type: 'WebRequest', config: { url: 'http://bing.com' } }, { name: 'Banana',  type: 'WebRequest', config: { url: 'http://yahoo.com' } }] })

    result = workflow.start(originating_data)

    render plain: result.to_json
  end

end
