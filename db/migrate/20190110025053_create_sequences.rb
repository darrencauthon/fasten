class CreateSequences < ActiveRecord::Migration[5.2]
  def change
    create_table :sequences do |t|
      t.text :name
      t.text :steps, limit: 4294967295
    end
  end
end
