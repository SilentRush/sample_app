require "../config/environment"

def createNewTournament(players, details)
  size = players.size
  size = 11
  tsize = (2 ** (Math.log(size, 2).ceil))
  pseedArr = seeding(size)
  pseedHash = {}
  players.each_with_index do |player,index|
    pseedHash["s#{index + 1}"] = player
  end
  puts pseedHash.to_s
  tournament = Tournament.new
  tournament.name = "Testing"
  tournament.date =  "10/12/16"
  tournament.description = "This is a test tournament"
  tournament.url = "http://test.test.com"
  sets = initializeSets(pseedArr, tsize, size, pseedHash)
  puts tournament.new_record?

end

def initializeSets(seed, tsize, size, players)
  setsArr = []
  setsInWinnerOne = 0
  setsInRound = (tsize/2)
  winnersRounds = Math.log(tsize, 2).ceil
  winnersRounds.times do |index|
    count = 0
    setsInRound.times do |i|
      set = Gameset.new()
      if index == 0
        topPlayer = Player.find_by(gamertag: players["s#{seed[count]}"])
        bottomPlayer = Player.find_by(gamertag: players["s#{seed[count+1]}"])
        puts topPlayer.gamertag.to_s if !topPlayer.nil?
        puts bottomPlayer.gamertag.to_s if !bottomPlayer.nil?
      end
      setsArr.push()
      count += 2
    end
    setsInRound /= 2
  end
  setsArr.push({round: winnersRounds + 1})
  setsArr.push({round: winnersRounds + 2})
=begin
  l2 = Math.log(tsize, 2)
  losersRounds = (l2).ceil + Math.log(l2,2).ceil
  totalP = 2**(l2.ceil)
  losersRounds -= 1 if((totalP * 0.75) >= size)
  losersRounds = 1 if tsize == 3
  losersRounds = 2 if tsize == 4
  losersRounds = 3 if tsize == 5 || size == 6
  losersRounds = 4 if tsize == 7 || size == 8

  setsInRound = ((2 ** (Math.log(tsize, 2).ceil))/2)/2
  nsize = (tsize / 2).round
  losersRounds.times do |index|
    count = 0
    numRounds = (setsInWinnerOne - setsInRound) if losersRounds % 2 == 0
    numRounds = setsInWinnerOne * 2 if losersRounds % 2 != 0
    setsInRound.times do |i|

    end
    if losersRounds % 2 != 0
      setsInRound /= 2 if (index + 1) % 2 != 0
    else
      setsInRound /= 2 if (index + 1) % 2 == 0
    end
  end
=end

  puts setsArr.to_s
  puts setsArr.size

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

player = ["Movement","jmlee337", "Chroma", "A-on", "Mascolino", "Ezmar", "Ivan", "Boston's Finest"]

createNewTournament  player, "something"
