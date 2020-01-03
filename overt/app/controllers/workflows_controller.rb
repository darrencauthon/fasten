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
                                   id:   'EventFormatter',
                                   name: 'Event Formatter',
                                   default_config: {
                                                     instructions: {
                                                                     full_name:  '{{first_name}} {{last_name}}',
                                                                   }
                                                   }
                                 },
                                 {
                                   id:   'HtmlParser',
                                   name: 'HTML Parser',
                                   default_config: {
                                                     path:    'body',
                                                     extract: {
                                                                title: {
                                                                         css: 'a',
                                                                         value: '@href'
                                                                       }
                                                              }
                                                   }
                                 },
                                 {
                                   id:   'JsonParser',
                                   name: 'JSON Parser',
                                   default_config: {
                                                     path: 'body'
                                                   }
                                 },
                                 {
                                   id:   'ConvertXmlToData',
                                   name: 'Convert XML to Data',
                                   default_config: {
                                                     path: 'one.two.three'
                                                   }
                                 },
                                 {
                                   id:   'Splitter',
                                   name: 'Splitter',
                                   default_config: {
                                                     path: 'one.two.three'
                                                   }
                                 },
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
                                   id:   'CrudInsert',
                                   name: 'Upsert Record',
                                   default_config: {
                                                     collection: 'TestRecords',
                                                     record_id: '{{id}}',
                                                     name: '{{name}}'
                                                   }
                                 },
                                 {
                                   id:   'ManualStart',
                                   name: 'ManualStart' ,
                                   default_config: {
                                   }
                                 },
                                 {
                                   id:   'WebEndpoint',
                                   name: 'WebEndpoint' ,
                                   default_config: {
                                   }
                                 },
                                 {
                                   id:   'WebEndpointJsonResponse',
                                   name: 'WebEndpointJsonResponse' ,
                                   default_config: {
                                   }
                                 },
                                 {
                                   id:   'CronEvent',
                                   name: 'CronEvent',
                                   default_config: {
                                     cron: '*/2 * * * *'
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
                       JSON.parse(JSON.parse(params[:workflow], symbolize_names: true)[:steps].to_json, symbolize_names: true)
                     else
                       []
                     end
    workflow.steps.each do |step|
      step.delete :shape
      step.delete :method
    end

    File.open("/workflows/#{workflow.id}.json", 'w') do |file|
      file.write JSON.pretty_generate(JSON.parse(workflow.to_json))
    end

    CronEvent.setup_all

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
