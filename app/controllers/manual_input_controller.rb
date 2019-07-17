class ManualInputController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @workflow_id = params[:workflow_id]
    @step_id = params[:step_id]
    render layout: 'boko'
  end

  def fire

    content = ''
    File.open("/workflows/#{params[:workflow_id]}.json") do |f|
      f.each_line { |l| content = content + l }
    end

    values = HashWithIndifferentAccess.new
    values[:definition] = JSON.parse content

    workflow = Workflow.build values[:definition]

    originating_event = Event.new(data: params[:event_data])
    step = workflow.steps.select { |x| x[:step_id] == params[:step_id] }.first
    originating_event.message = Mashing.mash_single_value step[:message], originating_event.data
    originating_event.run_id = SecureRandom.uuid

    result = workflow.start originating_event

    render json: { result: result, run_id: originating_event.run_id }

  end

end
