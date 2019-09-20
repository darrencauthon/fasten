class WorkflowsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Workflows'
    @optional_description = ''

    @workflows = Workflow.all

    render layout: 'adminlte'
  end

  def json
    workflow = get_workflow params[:id]

    render json: { workflow: workflow }
  end

  def step_types
    render json: {
                   step_types: [
                                 {
                                   id:   'Trigger',
                                   name: 'Trigger',
                                   default_config: {
                                                     rules: [
                                                              {
                                                                path:  'status',
                                                                type:  '==',
                                                                value: '200'
                                                              }
                                                            ]
                                                   }
                                 },
                                 {
                                   id:   'ManualStart',
                                   name: 'ManualStart' ,
                                   default_config: {
                                   }
                                 },
                                 {
                                   id:   'WebRequest',
                                   name: 'WebRequest',
                                   default_config: {
                                                     url: 'http://www.github.com',
                                                   }
                                 }
                               ]
                 }
  end

  def save

    workflow = get_workflow params[:id]

    workflow.steps = if (params[:workflow])
                       JSON.parse(JSON.parse(params[:workflow])['steps'].to_json).map { |_, v| v }
                     else
                       []
                     end

    File.open("/workflows/#{workflow.id}.json", 'w') do |file|
      file.write JSON.pretty_generate(JSON.parse(workflow.to_json))
    end

    render json: { workflow: workflow }
  end

  def edit
    @page_header = 'Edit Workflow'
    @optional_description = ''

    @workflow = get_workflow params[:id]

    render layout: 'adminlte'
  end

  private

  def get_workflow id
    workflow = Workflow.find params[:id]
    unless workflow
      workflow = Workflow.new
      workflow.id = params[:id]
    end
    workflow
  end

end
