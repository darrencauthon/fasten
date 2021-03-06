class WebRequest

  attr_accessor :config

  def receive(event)
    url = config[:url]

    get url
  end

  def get(url)

    conn = Faraday.new do |connection|
      connection.response :encoding
      connection.adapter Faraday.default_adapter
    end

    response = conn.get url

    {
      status: response.status,
      url: url,
      reason_phrase: response.reason_phrase,
      response_headers: response.headers,
      body: (config[:no_body].to_s.downcase.strip == 'true' ? '' : response.body)
    }
  end

end
