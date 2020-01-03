class CrudController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Records'
    @optional_description = ''

    @crud_records = CrudRecord.all.paginate(page: params[:page], per_page: 10)

    render layout: 'adminlte'
  end

  def view
    @page_header = 'Record'
    @optional_description = ''

    @crud_record = CrudRecord.find params[:id]

    render layout: 'adminlte'
  end

  def json
    @crud_record = CrudRecord.find params[:id]

    render json: @crud_record
  end

  def delete
    crud_record = CrudRecord.find params[:id]

    crud_record.delete

    render json: {}
  end

end
