class WebRequest

  attr_accessor :config

  def receive(event)

    url = config[:url]

    conn = Faraday.new do |connection|
      connection.response :encoding
      connection.adapter Faraday.default_adapter
    end

    method = (config[:method] || 'get').to_sym

    response = conn.send(method, url) do |req|
      if config.headers
      req.headers.clear
      raise req.inspect
    end

    {
      status: response.status,
      url: url,
      reason_phrase: response.reason_phrase,
      response_headers: response.headers,
      body: (config[:no_body] ? '' : response.body)
    }

  end

end
