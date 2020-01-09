class JsonParser

  attr_accessor :config

  def receive(event)

    path = config[:path]
    data = event.data[path]

    data ? JSON.parse(data) : {}

  end

end
