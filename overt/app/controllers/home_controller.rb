class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Home'
    @optional_description = ''

    render layout: 'water'
  end

end
