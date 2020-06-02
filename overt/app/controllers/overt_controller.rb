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

  def view_step
    @workflow = Workflow.find params[:workflow_id]
    @step = @workflow.steps.detect { |x| x[:id] == params[:id] }
    @event_id = params[:event_id]
    render layout: 'water'
  end

  def build_workflow
    render layout: 'water'
  end

  def build_step
    @workflow = Workflow.find params[:workflow_id]
    @event_id = params[:event_id]
    @step_types = StepType.all
    @parent_step_id = params[:parent_step_id]
    render layout: 'water'
  end

  def create_workflow
    workflow = Workflow.new
    workflow.id = params[:id]
    workflow.name = params[:name]
    workflow.save

    render json: { test: 'water' }
  end

  def create_a_new_step
    @id = params[:id] || SecureRandom.uuid
    @name = params[:name] || @id
    @event_id = params[:event_id]

    step_type = StepType.all.select { |x| x[:id] == params[:type] }.first
    config = step_type[:default_config] || {}

    step = {
              id: @id,
              name: @name,
              label: @id,
              merge: params[:merge],
              message: params[:message],
              type: params[:type],
              config: config,
              parent_step_ids: []
            }

    step[:parent_step_ids] = [params[:parent_step_id]] unless params[:parent_step_id].empty?

    event = params[:event_id] ? Event.where(id: params[:event_id]).first : nil
    step[:test_event] = event.data if event

    @workflow = Workflow.find params[:workflow_id]
    @workflow.steps << step

    @workflow.save

    render json: { test: 'water' }
  end

  def step_json
    workflow = Workflow.find params[:workflow_id]
    step = workflow.steps.detect { |x| x[:id] == params[:id] }
    event = (params[:event_id] ? Event.where(id: params[:event_id]).first : nil) || {}
    render json: { step: step, workflow: workflow, event: event }
  end

  def save_workflow
    workflow = Workflow.find params[:id]
    workflow.name = params[:name]

    workflow.save

    render json: { }
  end

  def save_step

    step = JSON.parse(params[:step])

    incoming_event = JSON.parse(params[:incoming_event])

    workflow = Workflow.find params[:id]

    workflow.steps = workflow.steps.map { |x| x[:id] == step['id'] ? step : x }
    workflow.save

    render json: { }

  end

end