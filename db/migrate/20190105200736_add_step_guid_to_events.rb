class AddStepGuidToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :step_guid, :string
  end
end
