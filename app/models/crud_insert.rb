class CrudInsert

  attr_accessor :config

  def receive event
    crud_record = CrudRecord.new(
                    id: SecureRandom.uuid,
                    data: event.data.to_hash,
                    collection_name: 'testing',
		    record_id: event.data[:word])

    crud_record.save

    event = Event.new
    event.data[:id] = crud_record.id
    event.data[:count] = CrudRecord.count
    event
  end

end
