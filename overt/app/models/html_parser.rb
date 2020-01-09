class HtmlParser

  attr_accessor :config

  def receive(event)

    doc = Nokogiri::HTML(event.data[config[:path]])

    matches = {}
    config['extract'].keys.each do |key|
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

    if config['output_as_a_single_event'].to_s != 'true'
      records
    else
      { (config[:single_event_path] || 'records') => records }
    end

  end

end
