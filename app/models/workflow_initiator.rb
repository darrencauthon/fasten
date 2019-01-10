class WorkflowInitiator
  def fire data
    Event.new message: "Received via web: #{data[:message]}"
  end
end