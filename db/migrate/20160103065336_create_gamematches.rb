class CreateGamematches < ActiveRecord::Migration
  def change
    create_table :gamematches do |t|
      t.integer :matchnum
      t.string :winner
      t.string :wchar
      t.string :loser
      t.string :lchar
      t.integer :wstock
      t.integer :lstock
      t.references :gameset, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
