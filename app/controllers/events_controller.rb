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

    sequence = Sequence.new
    sequence.name = steps[0][:name]
    sequence.steps = steps_encoded
    sequence.save

    render plain: 'ok'
  end

  def fire
    sequence = Sequence.where(name: params[:message]).first

    return render plain: "no sequence found for \"#{params[:message]}\"" unless sequence

    steps = JSON.parse(sequence.steps, symbolize_names: true)
    steps.each { |s| s[:config] = { name: s[:name] } }
    steps.unshift({ type: 'WorkflowInitiator' })

    workflow = Workflow.build(steps: steps)
    result = workflow.start({ message: params[:message] })

    render plain: result.to_json
  end

  def create_web

    originating_data = { url: params[:url] }

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_data)

    render plain: result.to_json
  end

  def create_with_tree

    originating_data = { url: params[:url] }

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build_given_a_hierarchy(first_step: { name: 'Apple', type: 'WebRequest', config: { url: 'http://google.com' }, next_steps: [{ name: 'Orange',  type: 'WebRequest', config: { url: 'http://bing.com' } }, { name: 'Banana',  type: 'WebRequest', config: { url: 'http://yahoo.com' } }] })

    result = workflow.start(originating_data)

    render plain: result.to_json
  end

end
