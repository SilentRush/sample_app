class CreateGamematches < ActiveRecord::Migration
  def change
    create_table :gamematches do |t|
      t.integer :matchnum
      t.string :wchar
      t.string :lchar
      t.integer :winner_id
      t.integer :loser_id
      t.string :map
      t.boolean :invalidMatch
      t.references :gameset, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true
      t.string :create_user_id

      t.timestamps null: false
    end
  end
end
