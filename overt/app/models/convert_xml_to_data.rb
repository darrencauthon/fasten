class ConvertXmlToData

  attr_accessor :config

  def receive(event)

    path = config[:path]

    segments = path.split '.'

    data = event.data[segments.shift]

    segments.each do |segment|
      data = data.send segment.to_sym
    end

    Hash.from_xml data

  end

end
