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
    render json: get_the_data
  end

  private

  def get_the_data
    {
      url: request.env['PATH_INFO'],
      method: request.env['REQUEST_METHOD'],
      form: request.env['rack.request.form_hash'],
      query: request.env['rack.request.query_hash'],
      raw: request.raw_post,
      headers: get_the_headers
    }
  end

  def get_the_headers
    headers = {}
    request.headers.each do |x|
      headers[x[0]] = x[1] if x[1].is_a?(String)
    end
    headers
  end

end
