require 'meleecharacter'

def getPlayers page
  @page = HTTParty.get(page)
  @parse_page = Nokogiri::HTML(@page)

  playersToTournament = []
  @parse_page.css('.match-player-name').each do |player|
      currPlayer = player.text
      playersToTournament.push(currPlayer) if !playersToTournament.include? currPlayer
  end
  puts playersToTournament.to_s
  return playersToTournament
end

def createTournament page
  @page = HTTParty.get(page)
  @parse_page = Nokogiri::HTML(@page)
  #create @tournament
  @tournament = Tournament.new

  tname = @parse_page.css('.tourney-details-affix-title').text
  tdate = @parse_page.css('.tourney-details-affix').css('div').last.text
  tsuffix = String.new
  @parse_page.css('.heading-no-margin-top').css('a').each do |word|
    tsuffix.empty? || tsuffix.nil? ? tsuffix = word.text : tsuffix += " - " + word.text
  end

  @tournament.name = tname
  @tournament.description = tsuffix
  @tournament.url = page
  @tournament.winnersRounds = 0
  @tournament.losersRounds = 0
  #@tournament.date = tdate
  @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round-heading').each do |a|
    if a.text.include?("Winners")
      @tournament.winnersRounds += 1
    elsif a.text.include?("Grand Finals")
      @tournament.winnersRounds += 1
    elsif a.text.include?("Losers")
      @tournament.losersRounds += 1
    end
  end

  @tournament.save
  params[:pcount].to_i.times do |i|
      currPlayer = Player.create(gamertag: params["Player#{i}"], name: "", characters: "", wins: 0, loses: 0, winrate: 0)
      currPlayer.tournaments << @tournament
      currPlayer.save
  end

  newPlayers = []
  params[:pcount].to_i.times do |i|
      newPlayers.push(params["Player#{i}"]) if !newPlayers.include? params["Player#{i}"]
  end
  origPlayers = []
  @parse_page.css('.match-player-name').each do |player|
      currPlayer = player.text
      origPlayers.push(currPlayer) if !origPlayers.include? currPlayer
  end

  playerHash = Hash.new
  newPlayers.each_with_index do |nplayer, index|
    playerHash[origPlayers[index]] = nplayer
  end

  loserCounter = 1
  winnerCounter = 1
  if @tournament.valid?
    @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each_with_index do |a, index|
      next if a.css('.bracket-round-heading').text.include?("Prog")
      round = 0
      roundname = a.css('.bracket-round-heading').text.downcase
      if (roundname.include?("grand") || roundname.include?("winners"))
        round = winnerCounter
        winnerCounter += 1
      end
      if roundname.include?("losers")
        round = -loserCounter
        loserCounter += 1
      end

      a.css('.match').map.each_with_index do |m, index|
        #create set
        setNum = (index + 1).to_s
        if m.text.blank?
          #blankplayer = Player.create(gamertag: "blankmatchbye", name: "blankmatchbye", characters: "", wins: 0, loses: 0, winrate: 0)
          #blankplayer = Player.find(gamertag: "blankmatchbye") if !blankplayer.save
          currSet = Gameset.create(roundNum: round, setnum: setNum, winner: nil, loser: nil, topPlayer: nil, bottomPlayer: nil, wscore: nil, lscore: nil, tournament_id: @tournament.id)
          currSet.save
        else
          match = m.css('.match-affix-wrapper')

          winner = Player
          if (match.css('.winner').css('.match-player-name').text.blank?)
            match.css('.match-player-name').css('.text-ellipsis').each do |w|
              !w.text.to_s.eql?(match.css('.loser').css('.match-player-name').text.to_s) ? winner = Player.find_by(gamertag: playerHash[w.text]) : next
            end
          else
            winner = Player.find_by(gamertag: playerHash[match.css('.winner').css('.match-player-name').text])
          end
          img = match.css('.winner').css('.match-character').css('img')
          wchars = []
          img.each do |link|
            character = MeleeCharacter.new(link['src'].split("/").last)
            wchars.push(character.get_character)
          end
          loser = Player
          if (match.css('.loser').css('.match-player-name').text.blank?)
            match.css('.match-player-name').css('.text-ellipsis').each do |l|
              !l.text.to_s.eql?(match.css('.winner').css('.match-player-name').text.to_s) ? loser = Player.find_by(gamertag: playerHash[l.text]) : next
            end
          else
            loser = Player.find_by(gamertag: playerHash[match.css('.loser').css('.match-player-name').text])
          end

          topPlayer = Player
          bottomPlayer = Player
          #find who is top player and who is bottom
          tplayer = match.css('.match-player-name').first
          bplayer = match.css('.match-player-name').last
          topPlayer = winner if winner.gamertag.eql?(playerHash[tplayer.text])
          topPlayer = loser if loser.gamertag.eql?(playerHash[tplayer.text])
          bottomPlayer = winner if winner.gamertag.eql?(playerHash[bplayer.text])
          bottomPlayer = loser if loser.gamertag.eql?(playerHash[bplayer.text])


          lchars = []
          img = match.css('.loser').css('.match-character').css('img')
          img.each do |link|
            character = MeleeCharacter.new(link['src'].split("/").last)
            lchars.push(character.get_character)
          end

          wscore = match.css('.winner').css('.match-player-stocks').text.to_i
          lscore = match.css('.loser').css('.match-player-stocks').text.to_i





          currSet = Gameset.create(roundNum: round, setnum: setNum, winner: winner, loser: loser, topPlayer: topPlayer, bottomPlayer: bottomPlayer, wscore: wscore, lscore: lscore, tournament_id: @tournament.id)
          winner.gamesets << currSet
          loser.gamesets << currSet
          currSet.save


          #create matches
          if((wscore.to_i + lscore.to_i).to_i > 0)
            (wscore.to_i + lscore.to_i).times do |i|
              if(i < wscore)
                currMatch = Gamematch.create(matchnum: i + 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), gameset_id: currSet.id, map: "", invalidMatch: false, tournament_id: @tournament.id)
                currMatch.save
              else
                currMatch = Gamematch.create(matchnum: i + 1, winner: loser, wchar: lchars.join(","), loser: winner, lchar: wchars.join(","), gameset_id: currSet.id, map: "", invalidMatch: false, tournament_id: @tournament.id)
                currMatch.save
              end
            end
          else
            currMatch = Gamematch.create(matchnum: 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), gameset_id: currSet.id, map: "", invalidMatch: true, tournament_id: @tournament.id)
            currMatch.save
          end
        end

      end
    end

  end
  return @tournament
end


#Pry.start(binding)
