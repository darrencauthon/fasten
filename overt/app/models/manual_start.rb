class ManualStart

  attr_accessor :config

  def receive(event)
    Event.new message: event.message, data: event.data
  end

end
