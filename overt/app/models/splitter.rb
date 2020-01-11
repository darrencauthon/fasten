class Splitter

  attr_accessor :config

  def receive(event)
    Mashing.dig config[:path], event.data
  end

end
