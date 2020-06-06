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

    workflow.steps = workflow.steps.map do |x|
      if x[:id] == step['id']
        step[:test_event] = x[:test_event]
        step
      else
        x
      end
    end

    workflow.save

    render json: { }
  end

  def save_test_event
    workflow = Workflow.find params[:id]
    step = workflow.steps.select { |x| x[:id] == params[:step_id] }.first
    if step && params[:test_event]
      step[:test_event] = JSON.parse(params[:test_event]) || {}
    end
    workflow.save
    render json: {}
  end

  def delete_step
    workflow = Workflow.find params[:id]

    workflow.steps = workflow.steps.select { |x| x[:id] != params[:step_id] }
    workflow.save

    render json: { }
  end

  def manual_starts

    @steps = Workflow.all
      .map { |x| x.steps.each { |s| s[:workflow_id] = x.id; s[:workflow_name] = x.name }; x.steps }
      .flatten
      .select { |x| x[:type] == 'ManualStart' }
      .flatten

    render layout: 'water'
  end

  def view_manual_start
    @workflow_id = params[:workflow_id]
    @step_id = params[:step_id]

    @step = Workflow.find(@workflow_id).steps
      .select { |x| x[:id] == @step_id }
      .first

    render layout: 'water'
  end

  def manual_start_json
    workflow_id = params[:workflow_id]
    step_id = params[:step_id]

    step = Workflow.find(workflow_id).steps
      .select { |x| x[:id] == step_id }
      .first

    render json: { step: step }
  end

  def records
    records = params[:collection] ? CrudRecord.where(collection_name: params[:collection]) : CrudRecord.all

    @records = records.paginate(page: params[:page], per_page: 10)

    render layout: 'water'
  end

  def view_record
    @record = CrudRecord.find params[:id]
    render layout: 'water'
  end

  def runs
    @runs = Run.all
               .where.not(workflow_id: nil)
               .order('created_at DESC')
               .paginate(page: params[:page], per_page: 10)

    workflows = @runs.group_by { |x| x.workflow_id }.keys
                     .map      { |x| Workflow.find x }
                     .select   { |x| x }
                     .map      { |x| [x.id, x.name] }
                     .to_h

    @runs_as_a_hash = @runs.map do |x|
      workflow = Workflow.find x.workflow_id
      event = Event.where(run_id: x.id).order(:created_at).first
      {
        id: x.id,
        created_at: x.created_at,
        message: event ? event.message : x.id,
        workflow_id: x.workflow_id,
        workflow_name: workflows[x.workflow_id],
      }
    end

    render layout: 'water'
  end

  def view_run
    @run = Run.find params[:id]

    render layout: 'water'
  end

  def run_json
    events = Event.where(run_id: params[:id])
                  .paginate(page: params[:page], per_page: 10)

    render json: { events: events, total_events: events.count }
  end

  def view_event
    @event = Event.find params[:id]

    @run = Run.find @event.run_id

    @related_events = {
      'Parent'   => Event.where(id: @event.parent_event_id),
      'Children' => Event.where(parent_event_id: @event.id),
      'Siblings' => Event.where(parent_event_id: @event.parent_event_id),
      'Cousins'  => Event.where(run_id: @event.run_id, step_id: @event.step_id),
    }.each { |_, v| v = v.paginate(page: params[:page], per_page: 10) }

    render layout: 'water'
  end

  def event_json
    event = Event.find params[:id]

    render json: { event: event }
  end

end