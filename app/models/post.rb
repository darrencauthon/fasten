class Post
  attr_accessor :config

  def receive(event)
    raise config.inspect
  end
end
