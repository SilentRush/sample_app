class PlayersTournaments < ActiveRecord::Migration
  def change
    create_table :players_tournaments, :id => false do |t|
      t.belongs_to :player, index: true
      t.belongs_to :tournament, index: true
      t.string :create_user_id
    end
  end
end
