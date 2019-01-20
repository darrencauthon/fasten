class JsonParser

  attr_accessor :config

  def receive(event)

    path = config[:path]
    json = event.data[path]

    event = Event.new data: JSON.parse(json)

    raise event.inspect

    event

  end

end
