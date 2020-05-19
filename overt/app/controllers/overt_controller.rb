class OvertController < ApplicationController

    def home
      render layout: 'water'
    end

    def workflows
      @workflows = Workflow.all
      render layout: 'water'
    end

    def workflow
      @workflow = Workflow.find params[:id]
      render layout: 'water'
    end

end