class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :date
      t.string :description
      t.string :url
      t.integer :winnersRounds
      t.integer :losersRounds
      t.boolean :isIntegration
      t.string :create_user_id

      t.timestamps null: false
    end
  end
end
