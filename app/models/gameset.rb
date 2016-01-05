class Gameset < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :winner, :class_name => 'Player', :foreign_key => 'winner_id'
  belongs_to :loser, :class_name => 'Player', :foreign_key => 'loser_id'
  has_many :gamematches, dependent: :destroy
end
