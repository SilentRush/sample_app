def createNewTournament(players, details)
  size = players.size
  size = 21
  pseedArr = seeding(size)
  puts pseedArr.to_s
  puts players.to_s
end

def seeding(numPlayers)
  rounds =  Math.log(numPlayers, 2).ceil - 1
  pls = [1,2]
  rounds.times do
    pls = nextLayer(pls)
  end
  return pls
end

def nextLayer(pls)
  out = []
  length = pls.size*2 + 1
  pls.each do |z|
    out.push(z)
    out.push(length-z)
  end
  return out
end

hash = { "1" => "p1", "2" => "p2", "3" => "p3", "4" => "p4", "5" => "p5", "6" => "p6" }
createNewTournament  hash, "something"
