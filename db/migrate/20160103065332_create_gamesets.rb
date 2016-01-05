class CreateGamesets < ActiveRecord::Migration
  def change
    create_table :gamesets do |t|
      t.string :name
      t.string :winner_id
      t.string :loser_id
      t.integer :setnum
      t.integer :wscore
      t.integer :lscore
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
