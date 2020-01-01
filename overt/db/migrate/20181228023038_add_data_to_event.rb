class AddDataToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :data, :text
  end
end
