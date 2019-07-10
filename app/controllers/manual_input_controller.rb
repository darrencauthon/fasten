class ManualInputController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'boko'
  end

  def fire
    render json: { event_data: params[:event_data] }
  end

end
