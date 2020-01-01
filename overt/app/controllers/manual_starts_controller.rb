class ManualStartsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Manual Starts'
    @optional_description = ''

    workflows = Workflow.all

    @steps = workflows
      .map { |x| x.steps.each { |s| s[:workflow_id] = x.id }; x.steps }
      .flatten
      .select { |x| x[:type] == 'ManualStart' }
      .flatten

    render layout: 'adminlte'
  end

  def view
    @workflow_id = params[:workflow_id]
    @step_id = params[:step_id]
    render layout: 'adminlte'
  end

  def fire

    content = ''
    File.open("/workflows/#{params[:workflow_id]}.json") do |f|
      f.each_line { |l| content = content + l }
    end

    values = HashWithIndifferentAccess.new
    values[:definition] = JSON.parse content

    workflow = Workflow.build values[:definition]

    originating_event = Event.new(data: params[:event_data])
    step = workflow.steps.select { |x| x[:id] == params[:step_id] }.first

    run = Run.start originating_event, step, workflow

    render json: { run_id: run.id }

  end

end
