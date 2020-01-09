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
    return value unless value.is_a? String
    Liquid::Template
      .parse(value)
      .render SymbolizedHash.new(data)
  end

  def self.arrayify value
    [value].flatten.join(',').split(',').select { |x| x }.map { |x| x.strip }
  end

  def self.dig(key, data)

    return nil unless key

    segments = key.split '.'

    data = data[segments.shift]

    segments.each do |segment|
      data = data.is_a?(Hash) ? data[segment] : data.send(segment.to_sym)
    end

    data
  end

end
