class CrudInsert

  attr_accessor :config

  def receive event

    crud_record = CrudRecord.where(collection_name: config[:collection],
                                   record_id: config[:record_id]).first

    action = crud_record ? 'updated' : 'created'

    unless crud_record
      crud_record = CrudRecord.new(
                      id: SecureRandom.uuid,
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
    new_event.data[:collection] = crud_record.collection_name
    new_event.data[:record_id] = crud_record.record_id
    new_event.data[:action] = action
    new_event
  end

end
