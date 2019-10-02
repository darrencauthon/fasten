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
    headers = {}
    request.headers.each do |x|
      headers[x[0]] = x[1] if x[1].is_a?(String)
    end
    data = {
      url: request.env['PATH_INFO'],
      method: request.env['REQUEST_METHOD'],
      headers: headers
    }
    raise data.inspect
    render json: data
  end

end
