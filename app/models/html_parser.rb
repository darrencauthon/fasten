class HtmlParser

  attr_accessor :config

  def receive(event)

    doc = Nokogiri::HTML(event.data[config[:path]])

    matches = {}

    config['extract'].each_with_index do |extract, index|
      matches[index] = doc.css(extract['css']).map { |x| x.xpath(extract['value']).to_s }
    end

    matches.keys.map do |key|
      Event.new data: matches[key]
    end

  end

end
