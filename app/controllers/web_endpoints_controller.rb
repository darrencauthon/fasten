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

    workflow = nil
    step = nil

    data = get_the_data

    Workflow.all.each do |w|
      w.steps.select { |x| x[:type] == 'WebEndpoint' }.each do |s|
        if s[:config] && s[:config][:url] == data[:url]
	  workflow = w
	  step = s
	end
      end
    end

    originating_event = Event.new(data: data)

    class << workflow
      attr_accessor :response
    end
    workflow.response = {}

    run = WebRun.start originating_event, step, workflow

    status  = workflow.response[:status]  || 200
    data    = workflow.response[:data]    || {}
    headers = workflow.response[:headers] || {}

    headers.each { |h| response.headers[h[0].to_s] = h[1] }

    render json: data, status: status.to_i
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
