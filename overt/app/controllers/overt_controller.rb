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
      @event_id = params[:event_id]
      render layout: 'water'
    end

    def create_step
      @workflow = Workflow.find params[:workflow_id]
      @event_id = params[:event_id]
      @step_types = StepType.all
      render layout: 'water'
    end

    def step_json
      workflow = Workflow.find params[:workflow_id]
      step = workflow.steps.detect { |x| x[:id] == params[:id] }
      event = (params[:event_id] ? Event.where(id: params[:event_id]).first : nil) || {}
      render json: { step: step, workflow: workflow, event: event }
    end

end