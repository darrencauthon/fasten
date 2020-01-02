class ConvertXmlToJson

  attr_accessor :config

  def receive(event)

    path = config[:path]

    segments = path.split '.'

    data = event.data[segments.shift]

    segments.each do |segment|
      data = data.send segment.to_sym
    end

    data = Hash.from_xml data

    Event.new data: data

  end

end
