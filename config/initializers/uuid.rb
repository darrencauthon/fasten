class Uuid < Liquid::Tag
  def initialize tag, arg, tokens
    super
  end

  def render context
    SecureRandom.uuid
  end
end

Liquid::Template.register_tag('_uuid', Uuid)
Liquid::Template.register_tag('_guid', Uuid)
