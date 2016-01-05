class GamematchesPlayers < ActiveRecord::Migration
  def change
    create_table :gamematches_players, :id => false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :gamematch, index: true
    end
  end
end
