class EventHandler

  def receive(event)
    Event.new message: "event ##{event.id} was fired"
  end

  def fire(data)
    Event.new message: data[:message]
  end

end
