class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def all
    render :json => Event.all
  end

  def create

    originating_event = Event.create(message: params[:message])

    steps = JSON.parse(request.body.read, symbolize_names: true)

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

  def create_web

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build(steps: steps)

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

  def create_with_tree

    originating_event = Event.create(message: 'Spark', data: {
      url: params[:url]
    })

    steps = [{ name: 'Apple',  type: 'WebRequest' }]

    workflow = Workflow.build_given_a_hierarchy(
      first_step: {
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
			              rules: [{path: 'status', value: '301'}] }
			  }
			]
                      }
		    ]
		  }
    )

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

  def demo

    Event.delete_all

    originating_event = Event.create(message: 'Demo Spark', data: {
      url: params[:url]
    })

    workflow = Workflow.build_given_a_hierarchy(
      first_step: {
        name:   'Get the data',
        type:   'WebRequest',
        config: { url: '{{url}}' },
        next_steps: [
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
                                                    message: 'This event has not happened in {{MinutesAgo}} minutes',
                                                    rules: [ { path: 'MinutesAgo', value: '0' } ]
                                                },
                                        next_steps: [
                                                      {
                                                        name: 'Format the data to send an alert',
                                                        type: 'EventFormatter',
                                                        config: {
                                                                  merge_mode: 'merge',
                                                                  message: 'Format the data to send an alert',
                                                                  instructions: { subject: 'this is the subject' }
                                                                },
                                                        next_steps: [
                                                                      {
                                                                        name: 'Send the notification',
                                                                        type: 'Post',
                                                                        config: {
                                                                                  message: 'Post the data',
                                                                                  url: 'the URL'
                                                                                  content_type: 'json',
                                                                                  method: 'POST',
                                                                                  headers: {}
                                                                                }
                                                                      }
                                                                    ]
                                                      }
                                                    ]
                                      }
                                    ]
                      }
                    ]
      }
    )

    result = workflow.start(originating_event)

    render plain: result.to_json
  end

end
