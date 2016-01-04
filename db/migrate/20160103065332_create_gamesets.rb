class CreateGamesets < ActiveRecord::Migration
  def change
    create_table :gamesets do |t|
      t.string :name
      t.integer :setnum
      t.string :winner
      t.string :loser
      t.integer :wscore
      t.integer :lscore
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
