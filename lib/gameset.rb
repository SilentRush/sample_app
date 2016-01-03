class GameSet < Round
  attr_accessor :setNum, :winner, :loser, :wscore, :lscore, :matches
  def initialize setNum = "", winner = "", loser = "", wscore = "", lscore = "", match = Array.new
    @setNum = setNum
    @winner = winner
    @loser = loser
    @wscore = wscore
    @lscore = lscore
    match.nil? ? @matches = Array.new : @matches = match
  end

  def addMatch match
    matches.push(match)
  end
end
