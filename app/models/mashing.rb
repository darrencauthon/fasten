module Mashing

  def self.mash(config, data)

    fields_not_to_mash = ['message']

    config
      .select { |_, y| y.is_a? String }
      .reject { |x, _| fields_not_to_mash.include? x.to_s }
      .each do |key, value|
        config[key] = mash_single_value(value, data)
      end

    config
      .select { |_, y| y.is_a? Hash }
      .reject { |x, _| fields_not_to_mash.include? x.to_s }
      .each do |key, value|
        config[key] = mash_all(value, data)
      end

    config
  end

  def self.mash_all(config, data)
    config
      .select { |_, y| y.is_a? String }
      .each do |key, value|
        config[key] = mash_single_value(value, data)
      end

    config
      .select { |_, y| y.is_a? Hash }
      .each do |key, value|
        config[key] = mash_all(value, data)
      end

    config
  end

  def self.mash_single_value(value, data)
    Liquid::Template
      .parse(value)
      .render SymbolizedHash.new(data)
  end

end
