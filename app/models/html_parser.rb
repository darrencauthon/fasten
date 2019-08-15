class HtmlParser

  attr_accessor :config

  def receive(event)

    doc = Nokogiri::HTML(event.data[config[:path]])

    matches = {}
    config['extract'].keys.each_with_index do |key, index|
      extract = config['extract'][key]
      matches[key] = doc.css(extract['css']).map { |x| x.xpath(extract['value']).to_s }
    end

    records = []
    matches[matches.keys.first].each_with_index do |x, i|
      record = {}
      matches.keys.each do |key|
        record[key] = matches[key][i]
      end
      records << record
    end

    records.map do |record|
      Event.new data: record
    end

  end

end
