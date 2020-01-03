class AllRecords

  attr_accessor :config

  def receive(event)

    records = CrudRecord.where(collection_name: config[:collection])

    records = records.limit(config[:limit]) if config[:limit].to_i > 0

    records
      .map { |x| { id: x.id, name: x.name, data: x.data } }
      .map { |x| Event.new data: x }

  end

end
