require 'web_scrapper'
class StaticPagesController < ApplicationController
  def home
    @tgen = TournamentGenerator.new("https://smash.gg/tournament/wunderland-ii-winter-wunderland/brackets/10648/3037/9640")
    @tournament = @tgen.createTournament
  end

  def help
  end

  def about
  end

  def contact
  end
end
