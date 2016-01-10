class CreateGamematches < ActiveRecord::Migration
  def change
    create_table :gamematches do |t|
      t.integer :matchnum
      t.string :wchar
      t.string :lchar
      t.string :winner_id
      t.string :loser_id
      t.string :map
      t.boolean :invalidMatch
      t.references :gameset, index: true, foreign_key: true
      t.references :tournament, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
