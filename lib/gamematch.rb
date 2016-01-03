class GameMatch < GameSet
  attr_accessor :matchNum, :winner, :wchar, :loser, :lchar, :wstock, :lstock
  def initialize matchNum = "", winner = "", wchar = "", loser = "", lchar = "", wscore = "", lscore = "", stage = ""
    @matchNum = matchNum
    @winner = winner
    @wchar = wchar
    @loser = loser
    @lchar = lchar
    @wstock = wscore
    @lstock = lscore
    @stage = stage
  end

end
