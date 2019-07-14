class WorkflowEditorController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @id = params[:id]
    render layout: 'boko'
  end

  def data
    content = ''
    File.open("/workflows/#{params[:id]}.json") do |f|
      f.each_line { |l| content = content + l }
    end
    render json: { workflow: JSON.parse(content) }
  end

  def save
    File.open("/workflows/#{params[:id]}.json", 'w') do |file|
      file.write params[:workflow].to_json
    end
    render json: { workflow: params[:workflow], id: params[:id] }
  end

end
