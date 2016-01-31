class PlayersController < ApplicationController
  autocomplete :player, :gamertag, :full => true

  def new
  end

  def create
  end

  def show
    @player = Player.find(params[:id])
  end

end
