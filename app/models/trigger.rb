class Trigger

  attr_accessor :config

  def receive(event)

    if (this_matches(event))
      Event.new data: event.data
    end

  end

  def this_matches(event)
    path     = config[:rules][0][:path]
    match_to = config[:rules][0][:value].to_s
    value    = event.data[path].to_s

    comparison_method = config[:rules][0][:type].to_sym
    value.send(comparison_method, match_to)
  end

end
