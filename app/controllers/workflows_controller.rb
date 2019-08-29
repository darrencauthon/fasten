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
    render json: { params: params }
  end

  def edit
    @page_header = 'Edit Workflow'
    @optional_description = ''

    @workflow = Workflow.find params[:id]

    render layout: 'adminlte'
  end

end
