class CrudInsert

  attr_accessor :config

  def receive event

    CrudRecord.where(collection_name: config[:collection], record_id: config[:word]).first

    crud_record = crud_record || CrudRecord.new(
                    id: SecureRandom.uuid,
                    data: event.data.to_hash,
                    collection_name: config[:collection],
		    record_id: config[:word])

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
