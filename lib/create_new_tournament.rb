
def createTournament(tournament, players, details)
  @size = players.size
  tsize = (2 ** (Math.log(@size, 2).ceil))
  pseedArr = seeding(@size)
  @tournament = tournament
  @tournament.name = "Test 16 Players"
  @tournament.date =  "10/12/16"
  @tournament.description = "This is a test tournament"
  #@tournament.url = "http://test.test.com"
  @tournament.save

  pseedHash = {}
  players.each_with_index do |player,index|
    currPlayer = Player.find(player)
    #currPlayer = Player.create(gamertag: player, name: "", characters: "", wins: 0, loses: 0, winrate: 0) if currPlayer.nil?
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
  return @tournament
end

def initializeSets(seed, tsize, players)
  puts seed.to_s
  tdetermine = tsize * 0.75
  lessthan = false

  tdetermine >= @size ? lessthan = true : lessthan = false

  if lessthan
    (tdetermine.to_i - @size).times do |index|
      bye = Player.find_by(gamertag: "bye")
      bye = Player.new(gamertag: "bye") if bye.nil?
      bye.save
      players["#{players.size + 1}"] = bye
    end
  end

  if !lessthan && @size < tsize
    (tsize - @size).times do |index|
      bye = Player.find_by(gamertag: "bye")
      bye = Player.new(gamertag: "bye") if bye.nil?
      bye.save
      players["#{players.size + 1}"] = bye
    end
  end

  if lessthan
    setsArr = []
    setsInWinnerOne = 0
    setsInRound = (tsize/2)
    byes = setsInRound / 2
    secondRound = []
    notUsed = []
    c = 0
    x = (seed.size/2)
    x.times do |count|
      if seed[c] <= byes || seed[c + 1] <= byes
        secondRound.push(seed[c]) if seed[c] <= byes
        secondRound.push(seed[c + 1]) if seed[c + 1] <= byes
      end
      if seed[c] > tdetermine || seed[c + 1] > tdetermine
        notUsed.push(seed[c]) if seed[c] > tdetermine
        notUsed.push(seed[c + 1]) if seed[c + 1] > tdetermine
      end
      c += 2
    end

    secondRound.each do |x|
        seed.delete(x)
    end

    notUsed.each do |x|
      seed.delete(x)
    end

    puts seed.to_s


    setsInRound = byes
    firstTime = true
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
        if index == 1
          topPlayer = players["#{secondRound[i]}"]
          puts topPlayer.gamertag.to_s if !topPlayer.nil?
          set.topPlayer = topPlayer
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
      setsInRound /= 2 if !firstTime
      firstTime = false
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
    losersRounds = (l2).ceil + Math.log(l2,2).ceil - 1
    totalP = 2**(l2.ceil)
    losersRounds = 1 if @size == 3
    losersRounds = 2 if @size == 4
    losersRounds = 3 if @size == 5 || @size == 6
    losersRounds = 4 if @size == 7 || @size == 8

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

  else

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
    losersRounds = 1 if @size == 3
    losersRounds = 2 if @size == 4
    losersRounds = 3 if @size == 5 || @size == 6
    losersRounds = 4 if @size == 7 || @size == 8

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
  end
  return setsArr

end

def updateSetTraversal(sets, tsize)

  tdetermine = tsize * 0.75
  lessthan = false

  tdetermine >= @size ? lessthan = true : lessthan = false

  if lessthan
    count = 0
    @tournament.winnersRounds.times do |index|
      sets.select{|x| x[:roundnum] == index + 1}.each_with_index do |set, i|
        if (index + 1) == 1
          loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1), set.setnum, @tournament.id).first
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
          set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
        elsif (index + 1) == 2
          setsInReverse = sets.select{|x| x[:roundnum] == index + 1}.reverse
          loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index), setsInReverse[i].setnum, @tournament.id).first
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
          set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
        elsif (index + 1) > 2 && (index + 1) < @tournament.winnersRounds - 2
          if (index + 1) % 2 == 0
            splitArr = sets.select{|x| x[:roundnum] == index + 1}
            splitArr = splitArr.each_slice((splitArr.size/2.0).round).to_a
            arr = splitArr[1] + splitArr[0]
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), arr[i].setnum, @tournament.id).first
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          else
            splitArr = sets.select{|x| x[:roundnum] == index + 1}
            splitArr = splitArr.each_slice((splitArr.size/2.0).round).to_a
            splitArr.each do |arr|
              arr.reverse!
            end
            arr = splitArr[0] + splitArr[1]
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), arr[i].setnum, @tournament.id).first
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
        else
          if (index + 1) == @tournament.winnersRounds - 2
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -@tournament.losersRounds, set.setnum, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
          if (index + 1) == @tournament.winnersRounds - 1
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
        end
      end
      count += 1 if index != 0 && index != 1
    end
    @tournament.losersRounds.times do |index|
      sets.select{|x| x[:roundnum] == -(index + 1)}.each_with_index do |set, i|
        if set.roundnum % 2 == 0
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 2), set.setnum, @tournament.id).first
          set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
        else
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
          set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
        end
        if (index + 1) == @tournament.losersRounds
          winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", @tournament.winnersRounds - 1, set.setnum, @tournament.id).first
          set.update(toWinnerSet: winnerSet) if !winnerSet.nil?
        end
      end
    end

  else
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
        elsif (index + 1) > 2 && (index + 1) < @tournament.winnersRounds - 2
          if (index + 1) % 2 == 0
            splitArr = sets.select{|x| x[:roundnum] == index + 1}
            splitArr = splitArr.each_slice((splitArr.size/2.0).round).to_a
            arr = splitArr[1] + splitArr[0]
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), arr[i].setnum, @tournament.id).first
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          else
            splitArr = sets.select{|x| x[:roundnum] == index + 1}
            splitArr = splitArr.each_slice((splitArr.size/2.0).round).to_a
            splitArr.each do |arr|
              arr.reverse!
            end
            arr = splitArr[0] + splitArr[1]
            puts "\n\n\n SPLIT ARRAY"
            puts splitArr[0].to_s
            puts splitArr[1].to_s
            puts "\n\n\n\n\n\n"
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -(index + 1 + count), arr[i].setnum, @tournament.id).first
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), (set.setnum.to_f/2).ceil, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
        else
          if (index + 1) == @tournament.winnersRounds - 2
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", -@tournament.losersRounds, set.setnum, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
          if (index + 1) == @tournament.winnersRounds - 1
            winnerSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            loserSet = Gameset.where("roundnum = ? AND setnum = ? AND tournament_id = ?", (index + 2), set.setnum, @tournament.id).first
            set.update(toLoserSet: loserSet, toWinnerSet: winnerSet) if !loserSet.nil? && !winnerSet.nil?
          end
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
