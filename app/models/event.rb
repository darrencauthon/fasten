class Event < ApplicationRecord
  serialize :data, JSON

  def symbolized_data
    SymbolizedHash.new data
  end
end
