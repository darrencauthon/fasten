class CreateRun < ActiveRecord::Migration[5.2]
  def change
    create_table :runs, id: false do |t|
      t.string :id, primary_key: true

      t.string :workflow_id

      t.timestamps
    end
  end
end
