class Trigger

  attr_accessor :config

  def receive(event)

    if (this_matches(event))
      event.data
    else
      nil
    end

  end

  def this_matches(event)
    config[:rules].all? { |r| this_rule_matches_this_event(r, event) }
  end

  def this_rule_matches_this_event(rule, event)
    path     = rule[:path]
    match_to = rule[:value].to_s
    value    = event.data[path].to_s

    comparison_method = rule[:type].to_sym
    value.send(comparison_method, match_to)
  end

end
