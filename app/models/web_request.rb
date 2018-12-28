class WebRequest

  def fire(data)
    response = Faraday.get data[:url]
    Event.new message: "test #{response.reason_phrase}", data: { 
      status: response.status,
      reason_phrase: response.reason_phrase,
      response_headers: response.headers
      #body: response.body
    }
  end

end
