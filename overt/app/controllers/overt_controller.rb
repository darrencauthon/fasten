class OvertController < ApplicationController

    skip_before_action :verify_authenticity_token

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
      @parent_step_id = params[:parent_step_id]
      render layout: 'water'
    end

    def create_a_new_step
      @id = params[:id] || SecureRandom.uuid
      @name = params[:name] || @id
      @event_id = params[:event_id]

      step = {
               id: @id,
               name: @name,
               label: @id,
               merge: params[:merge],
               message: params[:message],
               type: params[:type],
               config: StepType.all.first { |x| x[:id] == params[:type] }[:default_config] || {},
             }

      step[:parent_step_ids] = [params[:parent_step_id]] if params[:parent_step_id]

      event = params[:event_id] ? Event.where(id: params[:event_id]).first : nil
      step[:test_event] = event.data if event

      @workflow = Workflow.find params[:workflow_id]
      @workflow.steps << step
      @workflow.steps.each { |s| s.delete(:method) }

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