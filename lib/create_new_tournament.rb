require "../config/environment"

def createNewTournament(players, details)
  size = players.size
  size = 11
  pseedArr = seeding(size)
  tournament = Tournament.new
  tournament.name = "Testing"
  tournament.date =  "10/12/16"
  tournament.description = "This is a test tournament"
  tournament.url = "http://test.test.com"
  sets = initializeSets(pseedArr, size)
  puts tournament.new_record?

end

def initializeSets(seed, size)
  puts seed.to_s
  setsArr = []
  setsInWinnerOne = 0
  setsInRound = ((2 ** (Math.log(size, 2).ceil))/2)
  winnersRounds = Math.log(size, 2).ceil
  winnersRounds.times do |index|
    count = 0
    setsInRound.times do |i|
      if (index == 0)
        if (seed[count] > size || seed[count + 1] > size)
          puts seed[count].to_s + " vs " + seed[count + 1].to_s + " is not valid."
        else
          setsArr.push({ round: index + 1})
          setsInWinnerOne += 1
        end
        count += 2
      elsif (index == 1)
        if (seed[count] > size || seed[count + 1] > size)
          setsArr.push({ round: index + 1, bye: "yes"})
        else
          setsArr.push({ round: index + 1})
        end
        count += 2
      else
        setsArr.push({ round: index + 1})
      end
    end
    setsInRound /= 2
  end
  setsArr.push({round: winnersRounds + 1})
  setsArr.push({round: winnersRounds + 2})
  l2 = Math.log(size, 2)

  losersRounds = (l2).ceil + Math.log(l2,2).ceil
  totalP = 2**(l2.ceil)
  losersRounds -= 1 if((totalP * 0.75) >= size)
  losersRounds = 1 if size == 3
  losersRounds = 2 if size == 4
  losersRounds = 3 if size == 5 || size == 6
  losersRounds = 4 if size == 7 || size == 8

  setsInRound = ((2 ** (Math.log(size, 2).ceil))/2)/2
  nsize = (size / 2).round
  seed = seeding(nsize)
  puts seed.to_s
  losersRounds.times do |index|
    count = 0
    #puts setsInRound
    numRounds = (setsInWinnerOne - setsInRound) if losersRounds % 2 == 0
    numRounds = setsInWinnerOne * 2 if losersRounds % 2 != 0
    puts "num rounds: " + numRounds.to_s + " setsinwinneroone: " + setsInWinnerOne.to_s + " setsinround: " + setsInRound.to_s
    setsInRound.times do |i|
      if (index == 0  && numRounds != 0)
        if ((seed[count] > nsize - numRounds && seed[count] <= nsize) || (seed[count + 1] > nsize - numRounds && seed[count + 1] <= nsize))
          setsArr.push({ round: -(index + 1)})
        else
          puts seed[count].to_s + " vs " + seed[count + 1].to_s + " is not valid."
        end
        count += 2

      elsif (index == 1)
        if (seed[count] > nsize || seed[count + 1] > nsize)
          setsArr.push({ round: -(index + 1), bye: "yes"})
        else
          setsArr.push({ round: -(index + 1)})
        end
        count += 2
      else
        setsArr.push({ round: -(index + 1)})
      end
    end
    if losersRounds % 2 != 0
      setsInRound /= 2 if (index + 1) % 2 != 0
    else
      setsInRound /= 2 if (index + 1) % 2 == 0
    end
  end


  puts setsArr.to_s

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
