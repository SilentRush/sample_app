class Gamematch < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
  belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
  belongs_to :create_user, :class_name => 'User', :foreign_key => 'create_user_id'
  belongs_to :gameset

end
