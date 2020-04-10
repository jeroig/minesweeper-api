class CreateCells < ActiveRecord::Migration[5.2]
  def change
    create_table :cells do |t|
      t.integer :value, limit: 1
      t.integer :row, limit: 1
      t.integer :col, limit: 1
      t.integer :state, limit: 1
      t.references :board, foreign_key: true

      t.timestamps
    end
  end
end
