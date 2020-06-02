class Splitter

  attr_accessor :config

  def receive(event)
    events = Mashing.dig config[:path], event.data

    if config[:limit] && config[:limit].to_s == config[:limit].to_i.to_s
      events = events.take config[:limit]
    end

    events
  end

end
