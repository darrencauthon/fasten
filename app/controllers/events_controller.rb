class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def new_index
    @page_header = 'Events'
    @optional_description = 'things that happened'

    @events = Event.all

    render layout: 'adminlte'
  end

  def all
    events = params[:run_id] ? Event.where(run_id: params[:run_id]) : Event.all
    render :json => events
  end

  def single
    event = params[:id] ? Event.where(id: params[:id]) : []
    render :json => event.first
  end

  def create

    originating_event = Event.create(message: params[:message])

    definition = JSON.parse(request.body.read, symbolize_names: true)

    workflow = Workflow.build(definition)

    result = workflow.start(originating_event)

    render plain: result.to_json

  end

  def create_web

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    workflow = Workflow.build({
      steps: [{
        name: 'Apple',
        type: 'WebRequest',
        config: { url: '{{url}}' }
      }
    ]})

    result = workflow.start(originating_event)

    render plain: result.to_json

  end

  def create_with_tree

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    workflow = Workflow.build(
      steps: [{
        name: 'Apple',
        type: 'WebRequest',
        config: { url: '{{url}}' },
        next_steps: [
          {
            name: 'Banana',
            type: 'WebRequest',
            config: { url: '{{url | replace: "http:", "https:"}}' },
            next_steps: [
              {
                name: 'Orange',
                type: 'Trigger',
                config: { message: 'The web request was successful! Status: {{status}}',
                          rules: [{path: 'status', value: '200'}] }
              },
              {
                name: 'Mango',
                type: 'Trigger',
                config: { message: 'The web request was a redirect! Status: {{status}}',
                          rules: [{path: 'status', value: '301'}]
                }
              }
            ]
          }
        ]
      }]
    )

    result = workflow.start(originating_event)

    render plain: result.to_json

  end

  def demo

    Event.delete_all

    originating_event = Event.create(message: 'Demo Spark', data: {
      url: params[:url],
      api_url: params[:api_url],
      api_key: params[:api_key]
    })

    workflow = Workflow.build(
      steps: [{
        name:   'Get the data',
        type:   'WebRequest',
        config: { merge_mode: 'merge', url: '{{url}}' },
        next_steps: [
                      {
                        name:    'Set the response to 404',
                        type:    'ContextSetter',
                        config: {
                                  instructions: { status: '404' }
                                },
                      },
                      {
                        name:    'Parse the JSON data',
                        type:    'JsonParser',
                        config:  { merge_mode: 'merge', path: 'body', message: 'Date {{Date}} {{MinutesAgo}}}' },
                        path:    'body',
                        next_steps: [
                                      {
                                        name: 'Note when the event has not happened in time',
                                        type: 'Trigger',
                                        config: {
                                                    merge_mode: 'merge',
                                                    message: 'This event happened {{MinutesAgo}}, >= 1',
                                                    rules: [ { path: 'MinutesAgo', value: '1', type: '>=' } ]
                                                },
                                        next_steps: [
                                                      {
                                                        name: 'Format the data to send an alert',
                                                        type: 'EventFormatter',
                                                        config: {
                                                                  merge_mode: 'merge',
                                                                  message: 'Format the data to send an alert {{abc}}',
                                                                  instructions: { subject: 'this is the subject' }
                                                                },
                                                        next_steps: [
                                                                      {
                                                                        name: 'Send the notification',
                                                                        type: 'Post',
                                                                        config: {
                                                                                  message: 'Post the data',
                                                                                  url: '{{api_url}}',
                                                                                  content_type: 'json',
                                                                                  method: 'post',
                                                                                  headers: { "Authorization" => "{{api_key}}", "Content-Type" => 'application/json' }
                                                                                }
                                                                      }
                                                                    ]
                                                      }
                                                    ]
                                      }
                                    ]
                      }
                    ]
      }]
    )

    result = workflow.start(originating_event)

    render plain: result.to_json, status: (result.context[:status] || 200)

  end

  def load_workflow_and_run

    Event.delete_all

    values = HashWithIndifferentAccess.new
    params.each { |k, v| values[k] = v }

    content = ''
    File.open("/workflows/#{params[:workflow_id]}.json") do |f|
      f.each_line { |l| content = content + l }
    end

    values[:definition] = JSON.parse content

    data = {}
    values
      .reject { |k, _| [:action, :controller, :message, :file].include? k.to_sym }
      .each   { |k, v| data[k] = v }

    originating_event = Event.create(message: values[:message], data: data)

    workflow = Workflow.build values[:definition]

    result = workflow.start originating_event

    render plain: result.to_json, status: (result.context[:status] || 200)

  end

  def import_definition

    Event.delete_all

    values = HashWithIndifferentAccess.new
    params.each { |k, v| values[k] = v }

    values[:definition] = JSON.parse values[:definition]

    data = {}
    values
      .reject { |k, _| [:definition, :action, :controller, :message].include? k.to_sym }
      .each   { |k, v| data[k] = v }

    originating_event = Event.create(message: values[:message], data: data)

    definition = values[:definition]

    workflow = Workflow.build definition

    result = workflow.start originating_event

    render plain: result.to_json, status: (result.context[:status] || 200)

  end

end
