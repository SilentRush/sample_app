class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :gamertag
      t.string :name
      t.string :characters
      t.integer :wins
      t.integer :loses
      t.integer :winrate
      t.string :create_user_id

      t.timestamps null: false
    end
  end
end
