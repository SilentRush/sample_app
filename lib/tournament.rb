class Tournament
  attr_accessor :tname, :tdate, :tsuffix, :rounds
  def initialize tname = "", tdate = "", tsuffix = ""
    @tname = tname
    @tdate = tdate
    @tsuffix = tsuffix
    @rounds = Array.new
  end

  def addRound round
    @rounds.push(round)
  end
end
