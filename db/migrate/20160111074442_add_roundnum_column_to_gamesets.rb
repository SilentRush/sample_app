class AddRoundnumColumnToGamesets < ActiveRecord::Migration
  def change
    add_column :gamesets, :roundNum, :integer
  end
end
