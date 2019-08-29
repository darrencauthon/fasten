class WorkflowsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Workflows'
    @optional_description = ''

    @workflows = Workflow.all

    render layout: 'adminlte'
  end

  def json
    workflow = Workflow.find params[:id]

    render json: { workflow: workflow }
  end

  def save

    workflow = Workflow.find params[:id]

    workflow.steps = JSON.parse(params[:workflow][:steps].to_json).map { |_, v| v }

    File.open("/workflows/#{workflow.id}.json", 'w') do |file|
      file.write JSON.pretty_generate(JSON.parse(workflow.to_json))
    end

    render json: { workflow: workflow }
  end

  def edit
    @page_header = 'Edit Workflow'
    @optional_description = ''

    @workflow = Workflow.find params[:id]

    render layout: 'adminlte'
  end

end
