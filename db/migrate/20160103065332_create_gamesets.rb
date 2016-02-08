class CreateGamesets < ActiveRecord::Migration
  def change
    create_table :gamesets do |t|
      t.integer :winner_id
      t.integer :loser_id
      t.integer :topPlayer_id
      t.integer :bottomPlayer_id
      t.integer :toWinnerSet_id
      t.integer :toLoserSet_id
      t.string :url
      t.integer :setnum
      t.integer :wscore
      t.integer :lscore
      t.references :tournament, index: true, foreign_key: true
      t.string :create_user_id

      t.timestamps null: false
    end
  end
end
