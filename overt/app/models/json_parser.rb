class JsonParser

  attr_accessor :config

  def receive(event)

    path = config[:path]
    data = event.data[path]
    json = data ? JSON.parse(data) : {}

    Event.new data: json

  end

end
