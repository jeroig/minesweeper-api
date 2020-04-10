class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.integer :timer, limit: 2
      t.integer :state, limit: 1
      t.integer :rows, limit: 1
      t.integer :columns, limit: 1
      t.integer :mines, limit: 1
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
