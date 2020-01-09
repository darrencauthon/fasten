class ConvertXmlToData

  attr_accessor :config

  def receive(event)
    Hash.from_xml Mashing.dig(config[:path], event.data)
  end

end
