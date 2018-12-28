class EventHandler

  def receive(event)
    self.create_event message: "event ##{event.id} was fired",
    data: { testing: 'abcdef' },
    prior_event: event
  end

  def fire(data)
    self.create_event message: data[:message]
  end

  def create_event(data)
    Event.new message: data[:message]
  end

end
