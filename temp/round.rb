class Round < Tournament
  attr_accessor :roundName, :sets
  def initialize roundName = ""
    @roundName = roundName
    @sets = Array.new
  end

  def addSet set
    sets.push(set)
  end
end
