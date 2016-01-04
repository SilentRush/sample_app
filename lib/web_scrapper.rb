require 'meleecharacter'

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
  #@tournament.date = tdate

  players = Hash.new
  playersToTournament = []
  @parse_page.css('.match-player-name').each do |player|
    if !Player.exists?(:gamertag => player.text)
      currPlayer = Player.new(gamertag: player.text, name: "", characters: "", wins: 0, loses: 0, winrate: 0)
      currPlayer.save
      players[currPlayer.gamertag.to_s] = currPlayer
      playersToTournament.push(currPlayer.id)
    else
      currPlayer = Player.where(gamertag: player.text).first
      players[currPlayer.gamertag.to_s] = currPlayer
      playersToTournament.push(currPlayer.id)
    end
  end
  @tournament.players = playersToTournament

  @tournament.save

  @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each do |a|
    roundname = a.css('.bracket-round-heading').text.downcase.tr(" ", "_")
    a.css('.match-affix-wrapper').map.each_with_index do |match, index|
      #create set
      setNum = (index + 1).to_s
      winner = ""
      if (match.css('.winner').css('.match-player-name').text.blank?)
        match.css('.match-player-name').css('.text-ellipsis').each do |w|
          !w.text.to_s.eql?(match.css('.loser').css('.match-player-name').text.to_s) ? winner = w.text : next
        end
      else
        winner = match.css('.winner').css('.match-player-name').text
      end
      img = match.css('.winner').css('.match-character').css('img')
      wchars = []
      img.each do |link|
        character = MeleeCharacter.new(link['src'].split("/").last)
        wchars.push(character.get_character)
      end
      loser = ""
      if (match.css('.loser').css('.match-player-name').text.blank?)
        match.css('.match-player-name').css('.text-ellipsis').each do |l|
          !l.text.to_s.eql?(match.css('.winner').css('.match-player-name').text.to_s) ? loser = l.text : next
        end
      else
        loser = match.css('.loser').css('.match-player-name').text
      end
      lchars = []
      img = match.css('.loser').css('.match-character').css('img')
      img.each do |link|
        character = MeleeCharacter.new(link['src'].split("/").last)
        lchars.push(character.get_character)
      end

      wscore = match.css('.winner').css('.match-player-stocks').text.to_i
      lscore = match.css('.loser').css('.match-player-stocks').text.to_i

      currSet = Gameset.new(name: roundname, setnum: setNum, winner: winner, loser: loser, wscore:wscore, lscore:lscore, tournament_id: @tournament.id)
      currSet.save
      #create matches
      if((wscore.to_i + lscore.to_i).to_i > 0)
        (wscore.to_i + lscore.to_i).times do |i|
          currMatch = Gamematch.new(matchnum: i + 1, winner: "", wchar: wchars.join(","), loser: "", lchar: lchars.join(","), wstock:"", lstock:"", gameset_id: currSet.id)
          currMatch.save
        end
      else
        currMatch = Gamematch.new(matchnum: 1, winner: "", wchar: wchars.join(","), loser: "", lchar: lchars.join(","), wstock:"", lstock:"", gameset_id: currSet.id)
        currMatch.save
      end

      #update player wins and loses
      puts currSet.loser + " " + currSet.winner
      !wscore.blank? ? players[winner].update(wins: players[winner].wins += wscore) : players[winner].update(wins: players[winner].wins += 1)
      !lscore.blank? ? players[winner].update(loses: players[winner].loses  += lscore) : players[winner].update(loses: players[winner].loses  += 1)
      !wscore.blank? ? players[loser].update(wins: players[loser].wins  += lscore) : players[loser].update(wins: players[loser].wins  += 1)
      !lscore.blank? ? players[loser].update(loses: players[loser].loses  += wscore) : players[loser].update(loses: players[loser].loses  += 1)

      #update player characters
      wchars.each do |char|
        if !char.to_s.blank? && !players[winner].characters.include?(char)
          if(players[winner].characters.blank?)
            players[winner].update(characters: players[winner].characters = char)
          else
            players[winner].update(characters: players[winner].characters += "," + char)
          end
        end
      end
      lchars.each do |char|
        if !char.to_s.blank? && !players[loser].characters.include?(char)
          if(players[loser].characters.blank?)
            players[loser].update(characters: players[loser].characters += "," + char)
          else
            players[loser].update(characters: players[loser].characters = char)
          end
        end
      end
      currSet.tournament = @tournament
    end
  end
end


#Pry.start(binding)
