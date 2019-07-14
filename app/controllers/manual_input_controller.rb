class ManualInputController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'boko'
  end

  def fire

    params[:workflow_id] = 'simple'

    content = ''
    File.open("/workflows/#{params[:workflow_id]}.json") do |f|
      f.each_line { |l| content = content + l }
    end

    values = HashWithIndifferentAccess.new
    values[:definition] = JSON.parse content

    workflow = Workflow.build values[:definition]

    originating_event = Event.new(data: params[:event_data])
    step = workflow.steps[0]
    originating_event.message = Workflow.mash_single_value step[:message], originating_event
    originating_event.run_id = SecureRandom.uuid

    result = workflow.start originating_event

    render json: { result: result, run_id: originating_event.run_id }

  end

end
