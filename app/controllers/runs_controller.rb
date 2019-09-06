class RunsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Runs'
    @optional_description = ''

    @runs = Run.all

    render layout: 'adminlte'
  end

  def view
    @page_header = 'Runs'
    @optional_description = ''

    @run = Run.find params[:id]

    render layout: 'adminlte'
  end

end
