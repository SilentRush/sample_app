class PlayersController < ApplicationController
  autocomplete :player, :gamertag, :full => true

  def new
    @player = Player.new
    @player.gamertag = params[:gamertag]
    @player.save
    player = @player.as_json
    if !@player.valid?
      player["error"] = "Player already exists.";
    end
    respond_to do |format|
      format.json { render json: player, status: :created }
    end
  end

  def create
  end

  def show
    @player = Player.find(params[:id])
  end

end
