class EventHandler

  def receive(event); end
  
  def fire(data); end
  
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
