class ManualInputController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'boko'
  end

end
