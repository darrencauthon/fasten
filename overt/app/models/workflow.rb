class Workflow

  attr_accessor :id
  attr_accessor :steps
  attr_accessor :context

  def initialize
    self.context = SymbolizedHash.new
    self.steps = []
  end

  def self.find id
    all.select { |x| x.id == id }.first
  end

  def self.all
    files = Dir["/workflows/*.json"]
      .map do |x|
	content = ''
        File.open(x) { |f| f.each_line { |l| content = content + l } }
        JSON.parse content, symbolize_names: true
      end
      .map { |x| Workflow.build x }
  end

  def self.build(definition)
    workflow = Workflow.new

    workflow.id = definition[:id]

    workflow.steps = definition[:steps]

    workflow.steps.each do |step|
      set_up_the_method step, workflow
    end

    workflow
  end

  def self.set_up_the_method(step, workflow)

    step[:method] = lambda do |event|
      event_handler = Workflow.build_event_handler_for step, workflow

      event_handler.config = Mashing.mash(event_handler.config, event.data)

      events = [event_handler.receive(event)]
        .flatten
        .select { |x| x.is_a? Hash }

      carry = Mashing.arrayify(event_handler.carry)
      data_to_merge = get_the_data_to_merge event.data, event_handler.merge

      events = events
        .map do |raw_data|
          data = raw_data
          data = apply_the_carry(data, carry) if carry.any?
          data = data.merge(data_to_merge)
          Event.new(data:    data,
                    message: Mashing.mash_single_value(event_handler.message, raw_data.merge(event.data)))
        end

      events
        .select { |x| x.message.to_s == '' }
        .each   { |e| e.message = "Event #{e.id}" }

      events

    end

    step[:config] = SymbolizedHash.new if step[:config].nil?

  end

  def self.build_event_handler_for(step, workflow)
    event_handler = step[:type].constantize.new
    event_handler.config = SymbolizedHash.new(step[:config]) if event_handler.respond_to?(:config)
    event_handler.workflow = workflow if event_handler.respond_to?(:workflow)

    class << event_handler
      attr_accessor :message
      attr_accessor :merge
      attr_accessor :carry
    end
    event_handler.message = step[:message] || step[:config][:message]
    event_handler.merge   = step[:merge]   || step[:config][:merge]
    event_handler.carry   = step[:carry]

    event_handler
  end

  private

  def self.get_the_data_to_merge event, merge
    merge = Mashing.arrayify merge
    merge.include?('*') ? event : Mashing.fluff(merge.reduce({}) { |k, i| k[i] = Mashing.dig(i, event); k })
  end

  def self.apply_the_carry event, carry
    data = carry.reduce({}) { |t, i| t[i] = Mashing.dig(i, event); t }
    Mashing.fluff data
  end

end
