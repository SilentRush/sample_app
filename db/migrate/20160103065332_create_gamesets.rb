class CreateGamesets < ActiveRecord::Migration
  def change
    create_table :gamesets do |t|
      t.string :winner_id
      t.string :loser_id
      t.string :topPlayer_id
      t.string :bottomPlayer_id
      t.string :toWinnerSet_id
      t.string :toLoserSet_id
      t.string :url
      t.integer :setnum
      t.integer :wscore
      t.integer :lscore
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
