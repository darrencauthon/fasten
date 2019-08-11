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

    render json: { step: step, incoming_event: incoming_event }

  end

end
