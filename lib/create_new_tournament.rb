require "../config/environment"

def createNewTournament(players, details)
  size = players.size
  tsize = (2 ** (Math.log(size, 2).ceil))
  pseedArr = seeding(size)
  @tournament = Tournament.new
  @tournament.name = "Test 16 Players"
  @tournament.date =  "10/12/16"
  @tournament.description = "This is a test tournament"
  #@tournament.url = "http://test.test.com"
  @tournament.save

  pseedHash = {}
  players.each_with_index do |player,index|
    currPlayer = Player.find_by(gamertag: player)
    currPlayer = Player.create(gamertag: player, name: "", characters: "", wins: 0, loses: 0, winrate: 0) if currPlayer.nil?
    currPlayer.tournaments << @tournament
    currPlayer.save
    pseedHash["#{index + 1}"] = currPlayer
  end
  puts pseedHash.to_s

  sets = initializeSets(pseedArr, tsize, pseedHash)
  @tournament.update(winnersRounds: sets.select{|x| x[:roundnum] > 0}.last.roundnum, losersRounds: (sets.select{|x| x[:roundnum] < 0}.last.roundnum) * -1)
  updateSetTraversal(sets, tsize)
  @tournament.gamesets.each do |set|
    puts set.inspect
  end

end

def initializeSets(seed, tsize, players)
  setsArr = []
  setsInWinnerOne = 0
  setsInRound = (tsize/2)
  winnersRounds = Math.log(tsize, 2).ceil
  winnersRounds.times do |index|
    count = 0
    setsInRound.times do |i|
      set = Gameset.new()
      if index == 0
        topPlayer = players["#{seed[count]}"]
        bottomPlayer = players["#{seed[count+1]}"]
        puts topPlayer.gamertag.to_s if !topPlayer.nil?
        puts bottomPlayer.gamertag.to_s if !bottomPlayer.nil?
        set.topPlayer = topPlayer
        set.bottomPlayer = bottomPlayer
      end
      set.setnum = i + 1
      set.roundnum = index + 1
      set.tournament = @tournament
      set.save
      match = Gamematch.new(matchnum: 1, invalidMatch: true, gameset: set, wchar: "", lchar: "", map: "")
      match.save
      setsArr.push(set)
      count += 2
    end
    setsInRound /= 2
  end
  grandSetOne = Gameset.new(setnum: 1, roundnum: winnersRounds + 1, tournament_id: @tournament.id)
  grandSetTwo = Gameset.new(setnum: 1, roundnum: winnersRounds + 2, tournament_id: @tournament.id)
  grandSetOne.save
  grandSetTwo.save
  match1 = Gamematch.new(matchnum: 1, invalidMatch: true, gameset: grandSetOne, wchar: "", lchar: "", map: "")
  match2 = Gamematch.new(matchnum: 1, invalidMatch: true, gameset: grandSetTwo, wchar: "", lchar: "", map: "")
  match1.save
  match2.save
  setsArr.push(grandSetOne)
  setsArr.push(grandSetTwo)


  l2 = Math.log(tsize, 2)
  losersRounds = (l2).ceil + Math.log(l2,2).ceil
  totalP = 2**(l2.ceil)
  losersRounds -= 1 if((totalP * 0.75) >= tsize)
  losersRounds = 1 if tsize == 3
  losersRounds = 2 if tsize == 4
  losersRounds = 3 if tsize == 5 || tsize == 6
  losersRounds = 4 if tsize == 7 || tsize == 8

  setsInRound = (tsize/2)/2
  losersRounds.times do |index|
    count = 0
    setsInRound.times do |i|
      set = Gameset.new()
      set.setnum = i + 1
      set.roundnum = -(index + 1)
      set.tournament = @tournament
      set.save
      match = Gamematch.new(matchnum: 1, invalidMatch: true, gameset: set, wchar: "", lchar: "", map: "")
      match.save
      setsArr.push(set)
    end
    if losersRounds % 2 != 0
      setsInRound /= 2 if (index + 1) % 2 != 0
    else
      setsInRound /= 2 if (index + 1) % 2 == 0
    end
  end

  return setsArr

end

def updateSetTraversal(sets, tsize)
  count = 1
  @tournament.winnersRounds.times do |index|
    sets.select{|x| x[:roundnum] == index + 1}.each_with_index do |set, i|
      if (index + 1) == 1
        loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1), (set.setnum.to_f/2).ceil, @tournament.id).first
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
        set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
      elsif (index + 1) == 2
        setsInReverse = sets.select{|x| x[:roundnum] == index + 1}.reverse
        loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1), setsInReverse[i].setnum, @tournament.id).first
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
        set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
      else
        if (index + 1) % 2 == 0
          setsInReverse = sets.select{|x| x[:roundnum] == index + 1}.reverse
          loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), setsInReverse[i].setnum, @tournament.id).first
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
          set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
        else
          loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), set.setnum, @tournament.id).first
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
          set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
        end
      end
      if (index + 1) == @tournament.winnersRounds - 1
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
        loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
        set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
      end
    end
    count += 1 if index != 0 && index != 1
  end
  @tournament.losersRounds.times do |index|
    sets.select{|x| x[:roundnum] == -(index + 1)}.each_with_index do |set, i|
      if set.roundnum % 2 == 0
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
        set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
      else
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 2), set.setnum, @tournament.id).first
        set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
      end
      if (index + 1) == @tournament.losersRounds
        winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", @tournament.winnersRounds - 1, set.setnum, @tournament.id).first
        set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
      end
    end
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

player = ["1","2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17","18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32"]

createNewTournament  player, "something"
