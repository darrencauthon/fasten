class CrudInsert

  attr_accessor :config

  def receive event

    #CrudRecord.delete_all

    crud_record = CrudRecord.where(collection_name: config[:collection],
                                   record_id: config[:record_id]).first

    unless crud_record
      new_id = SecureRandom.uuid

      crud_record = CrudRecord.new(
                      id: new_id,
                      data: event.data.to_hash,
                      collection_name: config[:collection],
		      record_id: config[:record_id])
    end

    crud_record.name = config[:name] || crud_record.name

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
