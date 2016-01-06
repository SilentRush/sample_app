require 'web_scrapper'
class TournamentsController < ApplicationController
  def new
  end

  def create
    @uri = URI.parse(params[:url])
    if @uri.host.eql? "smash.gg"
      if(params[:method] == "Create")
        @tournament = createTournament(params[:url])
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
end
