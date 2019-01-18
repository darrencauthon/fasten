class Trigger

  attr_accessor :config

  def receive(event)

    if (this_matches(event))
      Event.new message: "this_matches", data: event.data
    end

  end

  def this_matches(event)
    path     = config[:rules][0][:path]
    match_to = config[:rules][0][:value].to_s
    value    = event.data[path].to_s

    value == match_to
  end

end
