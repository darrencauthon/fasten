class StarterController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'adminlte'
  end

  def step
    @page_header = 'Step Editor'
    @optional_description = 'Define the step here'

    home = Breadcrumb.new
    home.name = 'Home'
    home.href = '/'
    home.fa = 'dashboard'

    here = Breadcrumb.new
    here.name = 'Here'

    @breadcrumbs = [home, here]

    render layout: 'adminlte'
  end

  def run_step

    step = JSON.parse(params[:step])

    incoming_event = JSON.parse(params[:incoming_event])

    values = HashWithIndifferentAccess.new
    values[:definition] = {
      steps: [step]
    }

    originating_event = Event.new(data: incoming_event)

    workflow = Workflow.build values[:definition]

    step_off_of_the_built_workflow = workflow.steps.first

    run = Run.start originating_event, step_off_of_the_built_workflow, workflow

    events = Event.where(run_id: run.id).paginate(page: 1, per_page: params[:limit] || 10)

    render json: { run: run, events: events }

  end

end
