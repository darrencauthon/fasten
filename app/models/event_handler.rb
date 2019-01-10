class EventHandler

  attr_accessor :config

  def receive(event)
    name = self.config[:name] if self.respond_to?(:config) and self.config else '??'
    [Event.new(message: "event ##{event.id} was fired (#{name})")]
  end

  def fire(data)
    Event.new message: data[:message]
  end

end
