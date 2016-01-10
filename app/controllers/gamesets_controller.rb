class GamesetsController < ApplicationController
  def new

  end

  def create
    @gameset = Gameset.new(gameset_params)

    if @gameset.save
      redirect_to @gameset
    else
      render 'new'
    end
  end

  def show
  end

  def edit
    @set = Gameset.find(params[:id])
  end

  def batchMatch
    @gameset = Gameset.find(params[:id])
    (@gameset.wscore + @gameset.lscore).times do |match|
      winner = Player.find_by(gamertag: params["winner#{match}"])
      loser = Player.find_by(gamertag: params["loser#{match}"])
      params["winner#{match}"] = winner
      params["loser#{match}"] = loser
      if !@gameset.gamematches[match].nil?
        @gameset.gamematches[match].update(matchnum: match + 1, winner: params["winner#{match}"],
                                    wchar: params["wchar#{match}"], loser: params["loser#{match}"],
                                    lchar: params["lchar#{match}"], map: params["map#{match}"],
                                    invalidMatch: false)
      else
        gamematch = Gamematch.create(matchnum: match + 1, winner: params["winner#{match}"],
                                    wchar: params["wchar#{match}"], loser: params["loser#{match}"],
                                    lchar: params["lchar#{match}"], map: params["map#{match}"],
                                    invalidMatch: false)
        gamematch.gameset = @gameset
        gamematch.save
      end
    end

    redirect_to tournament_path @gameset.tournament
  end

  def update
    @gameset = Gameset.find(params[:id])
    winner = Player.find_by(gamertag: params[:winner])
    loser = Player.find_by(gamertag: params[:loser])
    params[:winner] = winner
    params[:loser] = loser

    if @gameset.update(gameset_params)
      redirect_to controller: "gamematchs", action: "batchMatch", id: @gameset.id
    else
      render 'edit'
    end
  end

  private
    def gameset_params
      params.permit(:winner, :loser, :wscore, :lscore)
    end
end
