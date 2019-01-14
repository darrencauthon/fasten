class Event < ApplicationRecord
  serialize :data, JSON

  after_initialize do |event|
    event.data = SymbolizedHash.new event.data
  end

  after_find do |event|
    event.data = SymbolizedHash.new event.data
  end
end
