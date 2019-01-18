class Trigger

  attr_accessor :config

  def receive event
    path  = config[:rules][0][:path]
    match = config[:rules][0][:value].to_s
    value = event.data[path].to_s
    if (match == value)
      Event.new message: "#{match}=#{value}", data: event.data
    end
  end

end
