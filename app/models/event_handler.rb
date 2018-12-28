class EventHandler

  def receive(event)
    self.create_event message: "event ##{event.id} was fired", prior_event: event
  end

  def fire(data)
    self.create_event message: data[:message]
  end

  def create_event(data)
    event = Event.new message: data[:message]
    event.prior_event_id = data[:prior_event].id if data.has_key?(:prior_event)

    event.save
    event
  end

end
