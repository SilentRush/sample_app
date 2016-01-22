def createNewTournament(players, details)
  size = players.size
  size = 6
  pseedArr = seeding(size)
  tournament = Hash.new
  tournament[:name] = "Testing"
  tournament[:date] =  "10/12/16"
  tournament[:description] = "This is a test tournament"
  tournament[:url] = "http://test.test.com"
  sets = initializeSets(pseedArr, size)
  tournament[:sets] = sets
  puts tournament.to_s

end

def initializeSets(seed, size)
  setsArr = []
  winners = Math.log(size, 2).ceil
  losers = (Math.log(size, 2)).ceil + Math.log((Math.log(size, 2)), 2).ceil
  puts winners
  puts losers
  winners.times do |index|
    puts index
  end
  losers.times do |index|
    puts index
  end

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

hash = Hash.new
hash = {
  "1" => "P1",
  "2" => "P2",
  "3" => "P3",
  "4" => "P4",
  "5" => "P5",
  "6" => "P6",
  "7" => "P7",
  "8" => "P8"
}

createNewTournament  hash, "something"
