class CrudInsert

  attr_accessor :config

  def receive event

    #CrudRecord.delete_all

    crud_record = CrudRecord.where(collection_name: event.data[:collection]).first || CrudRecord.new(
                    id: SecureRandom.uuid,
                    #data: event.data.to_hash,
                    collection_name: event.data[:collection],
		    record_id: event.data[:word])

    hash = crud_record.data || {}
    event.data.to_hash.each do |k, v|
      hash[k] = v
    end

    crud_record.data = hash

    crud_record.save

    new_event = Event.new
    new_event.data = event.data
    new_event.data[:id] = crud_record.id
    new_event.data[:count] = CrudRecord.count
    new_event
  end

end
