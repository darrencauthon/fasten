class WebEndpointJsonResponse

  attr_accessor :config
  attr_accessor :workflow

  def receive event
    event.data.each { |t| workflow.response[t.key] = t.value }
    nil
  end

end
