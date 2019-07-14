class WorkflowEditorController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'boko'
  end

  def data
    render json: {}
  end

end
