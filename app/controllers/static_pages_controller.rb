require 'web_scrapper'
class StaticPagesController < ApplicationController
  def home
    @tgen = TournamentGenerator.new("https://smash.gg/tournament/smash-summit/brackets/10727/2943/9440")
    @tournament = @tgen.createTournament
  end

  def help
  end

  def about
  end

  def contact
  end
end
