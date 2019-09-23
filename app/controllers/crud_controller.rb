class CrudController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'CRUD'
    @optional_description = ''

    @crud_records = CrudRecord.all

    render layout: 'adminlte'
  end

  def view
    @page_header = 'CRUD Record'
    @optional_description = ''

    @crud_record = CrudRecord.find params[:id]

    render layout: 'adminlte'
  end

  def json
    @crud_record = CrudRecord.find params[:id]

    render json: @crud_record
  end

end
