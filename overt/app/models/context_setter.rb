class ContextSetter

  attr_accessor :config
  attr_accessor :workflow

  def receive(event)
    config[:instructions].each do |key, value|
      workflow.context[key] = Mashing.mash_single_value(value, event.data)
    end
    nil
  end

end
