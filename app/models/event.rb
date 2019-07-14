class Event < ApplicationRecord
  serialize :data, JSON

  after_initialize { |x| x.id ||= SecureRandom.uuid }
end
