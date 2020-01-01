class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: false do |t|
      t.string :id, primary_key: true
      t.string :message

      t.timestamps
    end
  end
end
