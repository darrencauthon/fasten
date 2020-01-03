class AllRecords

  attr_accessor :config

  def receive(event)
    CrudRecord
      .where(collection_name: config[:collection])
      .map { |x| { id: x.id, name: x.name, data: x.data } }
      .map { |x| Event.new data: x }
  end

end
