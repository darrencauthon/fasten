class WebEndpointsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Web Endpoints'
    @optional_description = ''

    workflows = Workflow.all

    @steps = workflows
      .map { |x| x.steps.each { |s| s[:workflow_id] = x.id }; x.steps }
      .flatten
      .select { |x| x[:type] == 'WebEndpoint' }
      .flatten

    render layout: 'adminlte'
  end

  def fire
    render json: {}
  end

end
