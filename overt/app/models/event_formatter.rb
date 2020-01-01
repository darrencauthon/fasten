class EventFormatter

  attr_accessor :config

  def receive(event)
    data = SymbolizedHash.new
    config[:instructions].each do |key, value|
      data[key] = Mashing.mash_single_value(value, event.data)
    end
    Event.new data: data
  end

end
