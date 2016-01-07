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
  #@tournament.date = tdate

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


  if @tournament.valid?
    @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each do |a|
      roundname = a.css('.bracket-round-heading').text.downcase.tr(" ", "_")
      a.css('.match-affix-wrapper').map.each_with_index do |match, index|
        #create set
        setNum = (index + 1).to_s
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
        lchars = []
        img = match.css('.loser').css('.match-character').css('img')
        img.each do |link|
          character = MeleeCharacter.new(link['src'].split("/").last)
          lchars.push(character.get_character)
        end

        wscore = match.css('.winner').css('.match-player-stocks').text.to_i
        lscore = match.css('.loser').css('.match-player-stocks').text.to_i

        currSet = Gameset.create(name: roundname, setnum: setNum, winner: winner, loser: loser, wscore: wscore, lscore: lscore, tournament_id: @tournament.id)
        winner.gamesets << currSet
        loser.gamesets << currSet
        currSet.save
        #create matches
        if((wscore.to_i + lscore.to_i).to_i > 0)
          (wscore.to_i + lscore.to_i).times do |i|
            if(i < wscore)
              currMatch = Gamematch.create(matchnum: i + 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), wstock:"", lstock:"",gameset_id: currSet.id, map: "", invalidMatch: false, tournament_id: @tournament.id)
              currMatch.save
            else
              currMatch = Gamematch.create(matchnum: i + 1, winner: loser, wchar: lchars.join(","), loser: winner, lchar: wchars.join(","), wstock:"", lstock:"",gameset_id: currSet.id, map: "", invalidMatch: false, tournament_id: @tournament.id)
              currMatch.save
            end
          end
        else
          currMatch = Gamematch.create(matchnum: 1, winner: winner, wchar: wchars.join(","), loser: loser, lchar: lchars.join(","), wstock:"", lstock:"",gameset_id: currSet.id, map: "", invalidMatch: true, tournament_id: @tournament.id)
          currMatch.save
        end

      end
    end

  end
  return @tournament
end


#Pry.start(binding)
