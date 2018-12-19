class EventHandler

  def receive(event); end
  
  def fire(data); end
  
  def create_event(message, prior_event=nil)
    event = Event.new message: message
    event.prior_event_id = prior_event.id if prior_event

    event.save
    event
  end
  
end

class Apple < EventHandler

  def fire(data)
    create_event message: data[:message]
  end
  
end

class Orange < EventHandler

  def receive(event)
    create_event message: "event ##{event.id} was fired"
  end
  
end

class Banana < EventHandler

  def receive(event)
    create_event message: "event ##{event.id} was fired"
  end
  
end

class Pear < EventHandler

  def receive(event)
      create_event message: "event ##{event.id} was fired"
  end

end
