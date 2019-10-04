class WebEndpointJsonResponse

  attr_accessor :config
  attr_accessor :workflow

  def receive event
    event.data.each { |t| workflow.response[t[0]] = t[1] }
    nil
  end

end
