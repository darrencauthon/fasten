class CreateCrudRecord < ActiveRecord::Migration[5.2]
  def change
    create_table :crud_records, id: false do |t|
      t.string :id, primary_key: true
      t.string :collection_name
      t.string :record_id
      t.string :name
      t.text :data

      t.timestamps
    end
  end
end
