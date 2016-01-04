require 'web_scrapper'
class TournamentsController < ApplicationController
  def new
  end

  def create
    @uri = URI.parse(params[:url])
    if @uri.host.eql? "smash.gg"
      createTournament(params[:url])
      redirect_to tournament_path id: @tournament.id
      flash[:notice] = "Thanks for submitting these questions"
    else
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
