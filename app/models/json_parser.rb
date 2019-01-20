class JsonParser

  attr_accessor :config

  def receive(event)

    path = config[:path]
    json = event.data[path]

    Event.new data: JSON.parse(json)

  end

end
