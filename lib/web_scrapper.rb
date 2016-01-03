require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'
require 'meleecharacter'
require 'tournament'
require 'round'
require 'gameset'
require 'gamematch'

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

    @parse_page.css('.bracket-content').css('.bracket-section').css('.bracket-round').each do |a|
      roundname = a.css('.bracket-round-heading').text.downcase.tr(" ", "_")
      roundname.include?("progression") ? next : round = Round.new(roundname)
      a.css('.match-affix-wrapper').map.each_with_index do |match, index|
        #create set
        setNum = (index + 1).to_s
        winner = match.css('.winner').css('.match-player-name').text
        img = match.css('.winner').css('.match-character').css('img')
        characters = []
        img.each do |link|
          character = MeleeCharacter.new(link['src'].split("/").last)
          characters.push(character.get_character)
        end
        characters.empty? ? wchar = "" : wchar = characters.join(",")
        loser = match.css('.loser').css('.match-player-name').text
        characters = []
        img = match.css('.loser').css('.match-character').css('img')
        img.each do |link|
          character = MeleeCharacter.new(link['src'].split("/").last)
          characters.push(character.get_character)
        end
        characters.empty? ? lchar = "" : lchar = characters.join(",")
        wscore = match.css('.winner').css('.match-player-stocks').text
        lscore = match.css('.loser').css('.match-player-stocks').text

        #create matches
        matches = []
        (wscore.to_i + lscore.to_i).times do |i|
          currMatch = GameMatch.new(i + 1, "", wchar, "", lchar, "", "")
          matches.push(currMatch)
        end
        matches.push(currMatch = GameMatch.new) if matches.empty? 
        currSet = GameSet.new(setNum, winner, loser, wscore, lscore, matches)
        round.addSet currSet
      end
      tournament.addRound round
    end
    return tournament
  end
end


#Pry.start(binding)
