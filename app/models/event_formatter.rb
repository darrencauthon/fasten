class EventFormatter

  attr_accessor :config

  def receive(event)
    data = SymbolizedHash.new
    config[:instructions].each do |key, value|
      data[key] = Workflow.mash_single_value(value, event)
    end
    raise Event.new(data: data).inspect
  end

end
