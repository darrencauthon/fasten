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

    def step
      @workflow = Workflow.find params[:workflow_id]
      @step = @workflow.steps.detect { |x| x[:id] == params[:id] }
      render layout: 'water'
    end

    def step_json
      workflow = Workflow.find params[:workflow_id]
      step = workflow.steps.detect { |x| x[:id] == params[:id] }
      render json: { step: step }
    end

end