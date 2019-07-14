class AddPriorEventToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :parent_event_id, :string
  end
end
