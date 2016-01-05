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
  @tournament.url = page
  #@tournament.date = tdate

  @playersToTournament = []
  @sets = []
  @parse_page.css('.match-player-name').each do |player|
      currPlayer = Player.new(gamertag: player.text, name: "", characters: "", wins: 0, loses: 0, winrate: 0)
      currPlayer.save
      @playersToTournament.push(currPlayer) if currPlayer.valid?
  end

  @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each do |a|
    roundname = a.css('.bracket-round-heading').text.downcase.tr(" ", "_")
    a.css('.match-affix-wrapper').map.each_with_index do |match, index|
      #create set
      setNum = (index + 1).to_s
      winner = Player
      if (match.css('.winner').css('.match-player-name').text.blank?)
        match.css('.match-player-name').css('.text-ellipsis').each do |w|
          !w.text.to_s.eql?(match.css('.loser').css('.match-player-name').text.to_s) ? winner = Player.find_by(gamertag: w.text) : next
        end
      else
        winner = Player.find_by(gamertag: match.css('.winner').css('.match-player-name').text)
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
          !l.text.to_s.eql?(match.css('.winner').css('.match-player-name').text.to_s) ? loser = Player.find_by(gamertag: l.text) : next
        end
      else
        loser = Player.find_by(gamertag: match.css('.loser').css('.match-player-name').text)
      end
      lchars = []
      img = match.css('.loser').css('.match-character').css('img')
      img.each do |link|
        character = MeleeCharacter.new(link['src'].split("/").last)
        lchars.push(character.get_character)
      end

      wscore = match.css('.winner').css('.match-player-stocks').text.to_i
      lscore = match.css('.loser').css('.match-player-stocks').text.to_i

      currSet = Gameset.new(name: roundname, setnum: setNum, winner: winner, loser: loser, wscore:wscore, lscore:lscore)
      currSet.save
      winner.gamesets << currSet
      loser.gamesets << currSet
      @sets.push(currSet)
      #create matches
      if((wscore.to_i + lscore.to_i).to_i > 0)
        (wscore.to_i + lscore.to_i).times do |i|
          if(i < wscore)
            currMatch = Gamematch.new(matchnum: i + 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), wstock:"", lstock:"", gameset_id: currSet.id, invalidMatch: false)
          else
            currMatch = Gamematch.new(matchnum: i + 1, winner: loser, wchar: wchars.join(","), loser: winner, lchar: lchars.join(","), wstock:"", lstock:"", gameset_id: currSet.id, invalidMatch: false)
          end
          currMatch.save
        end
      else
        currMatch = Gamematch.new(matchnum: 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), wstock:"", lstock:"", gameset_id: currSet.id, invalidMatch: true)
        currMatch.save
      end

    end
  end
  return @tournament
end


#Pry.start(binding)
