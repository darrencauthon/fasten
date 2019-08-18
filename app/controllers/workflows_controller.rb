class WorkflowsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Workflows'
    @optional_description = ''

    @workflows = Workflow.all

    render layout: 'adminlte'
  end

end
