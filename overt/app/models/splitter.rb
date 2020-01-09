class Splitter

  attr_accessor :config

  def receive(event)

    path = config[:path]

    segments = path.split '.'

    data = event.data[segments.shift]

    segments.each do |segment|
      data = data.is_a?(Hash) ? data[segment] : data.send(segment.to_sym)
    end

    data

  end

end
