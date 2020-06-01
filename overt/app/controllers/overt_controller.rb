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

    def create_a_new_step
      @workflow = Workflow.find params[:workflow_id]
      @id = SecureRandom.uuid
      @event_id = params[:event_id]

      step = {
               id: @id,
               name: @id,
               label: @id,
               type: params[:type],
               parent_step_ids: [params[:parent_step_id]]
             }
      @workflow.steps << step

      File.open("/workflows/#{@workflow.id}.json", 'w') do |file|
        file.write JSON.pretty_generate(JSON.parse(@workflow.to_json))
      end

      CronEvent.setup_all

      render json: { test: 'water' }
    end

    def step_json
      workflow = Workflow.find params[:workflow_id]
      step = workflow.steps.detect { |x| x[:id] == params[:id] }
      event = (params[:event_id] ? Event.where(id: params[:event_id]).first : nil) || {}
      render json: { step: step, workflow: workflow, event: event }
    end

end