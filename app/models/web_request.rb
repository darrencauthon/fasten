class WebRequest

  attr_accessor :config

  def fire(data)
    url = data[:url] || config[:url]

    conn = Faraday.new do |connection|
      connection.response :encoding
      connection.adapter Faraday.default_adapter
    end


    response = conn.get url
    Event.new message: "#{url} reported #{response.status}", data: {
      status: response.status,
      reason_phrase: response.reason_phrase,
      response_headers: response.headers,
      body: response.body
    }
  end

end
