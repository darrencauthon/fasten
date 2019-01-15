class CreateWorkflows < ActiveRecord::Migration[5.2]
  def change
    create_table :workflows do |t|
      t.text :name
      t.text :steps_encoded_as_json, limit: 4294967295
    end
  end
end
