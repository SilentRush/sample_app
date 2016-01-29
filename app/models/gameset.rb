class Gameset < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
  belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
  belongs_to :topPlayer, :class_name => 'Player', :foreign_key => 'topPlayer_id'
  belongs_to :bottomPlayer, :class_name => 'Player', :foreign_key => 'bottomPlayer_id'
  belongs_to :toWinnerSet, :class_name => 'Gameset', :foreign_key => 'toWinnerSet_id'
  belongs_to :toLoserSet, :class_name => 'Gameset', :foreign_key => 'toLoserSet_id'
  has_many :gamematches, dependent: :destroy
end
