require 'meleecharacter'
require 'tournament'
require 'round'
require 'gameset'
require 'gamematch'
require 'player'

class TournamentGenerator

  def initialize page = ""
    #grab webpage
    @page = HTTParty.get(page.to_s)
    @parse_page = Nokogiri::HTML(@page)
  end

  def createTournament
    #create tournament
    tournament = Tournament.new

    tname = @parse_page.css('.tourney-details-affix-title').text
    tdate = @parse_page.css('.tourney-details-affix').css('div').last.text
    tsuffix = String.new
    @parse_page.css('.heading-no-margin-top').css('a').each do |word|
      tsuffix.empty? || tsuffix.nil? ? tsuffix = word.text : tsuffix += " - " + word.text
    end

    tournament.tname = tname
    tournament.tsuffix = tsuffix
    tournament.tdate = tdate

    players = Hash.new
    @parse_page.css('.match-player-name').each do |player|
      currPlayer = Player.new ()
      currPlayer.gamertag = player.text
      players[currPlayer.gamertag] = currPlayer
    end
    tournament.players = players

    @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each do |a|
      roundname = a.css('.bracket-round-heading').text.downcase.tr(" ", "_")
      roundname.include?("progression") ? next : round = Round.new(roundname)
      a.css('.match-affix-wrapper').map.each_with_index do |match, index|
        #create set
        setNum = (index + 1).to_s

        winner = match.css('.winner').css('.match-player-name').text
        img = match.css('.winner').css('.match-character').css('img')
        wchars = []
        img.each do |link|
          character = MeleeCharacter.new(link['src'].split("/").last)
          wchars.push(character.get_character)
        end

        loser = match.css('.loser').css('.match-player-name').text
        lchars = []
        img = match.css('.loser').css('.match-character').css('img')
        img.each do |link|
          character = MeleeCharacter.new(link['src'].split("/").last)
          lchars.push(character.get_character)
        end

        wscore = match.css('.winner').css('.match-player-stocks').text.to_i
        lscore = match.css('.loser').css('.match-player-stocks').text.to_i

        #create matches
        matches = []
        (wscore.to_i + lscore.to_i).times do |i|
          currMatch = GameMatch.new(i + 1, "", wchars.join(","), "", lchars.join(","), "", "")
          matches.push(currMatch)
        end
        matches.push(currMatch = GameMatch.new) if matches.empty?
        currSet = GameSet.new(setNum, winner, loser, wscore, lscore, matches)
        round.addSet currSet

        #update player wins and loses
        players[winner].wins += wscore
        players[winner].loses += lscore
        players[loser].wins += lscore
        players[loser].loses += wscore
        
        #update player characters
        wchars.each do |char|
          players[winner].characters.push(char) if !char.empty? && !players[winner].characters.include?(char)
        end
        lchars.each do |char|
          players[loser].characters.push(char) if !char.empty? && !players[loser].characters.include?(char)
        end
      end
      tournament.addRound round
    end
    return tournament
  end
end


#Pry.start(binding)
