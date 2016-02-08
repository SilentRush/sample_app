class GamesetsPlayers < ActiveRecord::Migration
  def change
    create_table :gamesets_players, :id => false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :gameset, index: true
      t.string :create_user_id
    end
  end
end
