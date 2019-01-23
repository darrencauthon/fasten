class Post
  attr_accessor :config

  def receive(event)

    data = {
      recipients: [ { address: { email: 'darren@cauthon.com' } } ],
      content: {
        from: {
	  email: 'darren@cauthon.com'
	},
	subject: 'Test',
	html: 'html',
      }
    }

    faraday = Faraday.new do |connection|
      connection.response :encoding
      connection.adapter Faraday.default_adapter
    end

    response = faraday.run_request(config[:method].to_sym,
                 config[:url], data.to_json, config[:headers])

    Event.new data: {
      status: response.status,
      url: config[:url],
      reason_phrase: response.reason_phrase,
      response_headers: response.headers,
      body: response.body,
    }
  end
end
