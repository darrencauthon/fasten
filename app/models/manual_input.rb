class ManualInput

  attr_accessor :config

  def receive(event)
    Event.new data: event.data
  end

  def get(url)

    conn = Faraday.new do |connection|
      connection.response :encoding
      connection.adapter Faraday.default_adapter
    end

    response = conn.get url
    Event.new data: {
      status: response.status,
      url: url,
      reason_phrase: response.reason_phrase,
      response_headers: response.headers,
      body: response.body
    }
  end

end
