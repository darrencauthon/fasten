class WebEndpoint

  attr_accessor :config

  def receive event
    event.data
  end

end
