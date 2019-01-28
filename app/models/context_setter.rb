class ContextSetter

  attr_accessor :config
  attr_accessor :workflow

  def receive(event)
    config[:instructions].each do |key, value|
      workflow.context[key] = Workflow.mash_single_value(value, event)
    end
  end

end
