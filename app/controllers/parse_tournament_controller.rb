require 'web_scrapper'
class ParseTournamentController < ApplicationController
  def parse

  end

  def players
    #if !params[:url].nil?
    puts params[:url].to_s
      @uri = URI.parse(params[:url])
      if @uri.host.eql? "smash.gg"
        if(params[:method] == "Get Players")
          @players = getPlayers(params[:url])
          if @players.empty? == false
            flash[:notice] = "Successfully grabbed players!"
          else
            flash[:error] = "Failed to grab players!"
          end
        end
      end
    #end
  end
end
