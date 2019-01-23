class Trigger

  attr_accessor :config

  def receive(event)

    if (this_matches(event))
      Event.new data: event.data
    end

  end

  def this_matches(event)
    rule = config[:rules][0]
    path     = rule[:path]
    match_to = rule[:value].to_s
    value    = event.data[path].to_s

    comparison_method = rule[:type].to_sym
    value.send(comparison_method, match_to)
  end

end
