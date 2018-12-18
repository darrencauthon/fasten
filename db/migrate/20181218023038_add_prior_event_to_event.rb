class AddPriorEventToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :prior_event, :integer
  end
end
