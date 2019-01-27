class EventHandler

  attr_accessor :config

  def receive(event)
    [Event.new(message: "event ##{event.id} was fired"),
     Event.new(message: "hello world")]
  end

end
