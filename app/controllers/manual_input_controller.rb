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

    originating_event = Event.create(message: 'Darren', data: params[:event_data])

    workflow = Workflow.build values[:definition]

    result = workflow.start originating_event

    render json: { result: result }

  end

end
