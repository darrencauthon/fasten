class AddWorkflowIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :workflow_id, :string
  end
end
