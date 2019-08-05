class StarterController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    render layout: 'adminlte'
  end

  def step
    render layout: 'adminlte'
  end

end
