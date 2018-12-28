class Event < ApplicationRecord
  serialize :data, JSON
end
