class AddRunGuidToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :run_id, :string
  end
end
