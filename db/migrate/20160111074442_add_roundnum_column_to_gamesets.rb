class AddRoundnumColumnToGamesets < ActiveRecord::Migration
  def change
    add_column :gamesets, :roundnum, :integer
  end
end
