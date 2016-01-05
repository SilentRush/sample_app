class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :date
      t.string :description
      t.string :url

      t.timestamps null: false
    end
  end
end
