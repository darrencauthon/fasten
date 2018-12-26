class SubscriptionHandler
  def receive subscription_data
    event_handler_type = subscription_data.event_handler_type
    prior_event = subscription_data.prior_event

    event = event_handler_type.new.receive prior_event
  end
end
