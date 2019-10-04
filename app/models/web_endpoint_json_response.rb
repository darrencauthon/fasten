class WebEndpointJsonResponse

  attr_accessor :config
  attr_accessor :workflow

  def receive event

    workflow.response[:status] ||= config[:status]

    workflow.response[:headers] ||= {}

    (config[:headers] || {}).each do |header|
      workflow.response[:headers][header[0]] = header[1]
    end

    workflow.response[:data] ||= {}

    event.data.each { |t| workflow.response[:data][t[0]] = t[1] }

    nil
  end

end
