require 'csv'

class ParseCsv

  attr_accessor :config

  def receive event
    data = event.data[config[:key]]

    headers = (config[:headers].to_s.downcase == 'true' ? true : false)

    rows = CSV.new data, headers: headers

    rows.map do |row|
      if headers
        row.to_hash
      else
	data = {}
	row.each_with_index { |r, i| data[i] = r }
        data
      end
    end

  end

end
