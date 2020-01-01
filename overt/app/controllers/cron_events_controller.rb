class CronEventsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    @page_header = 'Cron Events'
    @optional_description = ''

    workflows = Workflow.all

    @steps = workflows
      .map { |x| x.steps.each { |s| s[:workflow_id] = x.id }; x.steps }
      .flatten
      .select { |x| x[:type] == 'CronEvent' }
      .flatten

    render layout: 'adminlte'
  end

end
