require 'web_scrapper'
require 'create_new_tournament'
class TournamentsController < ApplicationController
  include GamesetsHelper

  def new
    @player = Player.all
  end

  def createNewTournament
    valid = true
    @tournament = Tournament.new
    if !params[:player].nil?
      players = []
      params[:player].each do |player|
        players.push(player[:id])
      end
      if players.size > 2
        @tournament = createTournament(@tournament, players, "something")
        @tournament.gamesets.each do |set|
          updateByes set
        end
        redirect_to tournament_path id: @tournament.id
      else
        flash[:error] = "Minimum players in a tournament is 3!"
        valid = false;
      end
    else
      flash[:error] = "Please enter players!"
      valid = false
    end
    redirect_to new_tournament_path if !valid
  end

  def create
    @uri = URI.parse(params[:url])
    if @uri.host.eql? "smash.gg"
      if(params[:method] == "Create")
        @tournament = importTournament(params[:url])
        if @tournament.valid?
          flash[:notice] = "Successfully Created Tournament!"
          redirect_to tournament_path id: @tournament.id
        else
          flash[:error] = "Failed to create Tournament!"
          redirect_to parseTournament_path
        end
      end
    else
      flash[:notice] = "Going to new page"
      render new
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def index
    @tournaments = Tournament.all
  end

  def getSetData
    @set = Gameset.find(params[:id])
    set = @set.as_json
    tplayer = @set.topPlayer.as_json
    bplayer = @set.bottomPlayer.as_json
    set["topPlayer"] = tplayer
    set["bottomPlayer"] = bplayer
    matches = []
    @set.gamematches.each do |match|
      matches.push match.as_json
    end
    set["matches"] = matches

    respond_to do |format|
      format.json { render json: set, status: :created }
    end
  end

end
