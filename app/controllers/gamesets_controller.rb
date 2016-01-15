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
    wscore = 0
    lscore = 0
    winner = Player
    loser = Player
    tplayerScore = 0
    bplayerScore = 0
    wscore = 0
    lscore = 0

    params[:matchCount].to_i.times do |index|
      tplayerScore += 1 if params["topPlayer#{index + 1}"].eql?("Win")
      bplayerScore += 1 if params["bottomPlayer#{index + 1}"].eql?("Win")
    end
    if tplayerScore > bplayerScore
      winner = Player.find_by(gamertag: params[:topPlayer])
      loser = Player.find_by(gamertag: params[:bottomPlayer])
      wscore = tplayerScore
      lscore = bplayerScore
    else
      loser = Player.find_by(gamertag: params[:topPlayer])
      winner = Player.find_by(gamertag: params[:bottomPlayer])
      wscore = bplayerScore
      lscore = tplayerScore
    end

    puts wscore
    puts lscore

    if @gameset.update(wscore: wscore, lscore: lscore, winner: winner, loser: loser)
      params[:matchCount].to_i.times do |index|
        matchnum = index + 1
        wchar = ""
        lchar = ""
        winner = Player
        loser = Player
        map = params["map#{index + 1}"]
        match = Gamematch.find_by(matchnum: index + 1)
        match = Gamematch.create() if !match.valid?
        if params["topPlayer#{index + 1}"].eql?("Win")
          wchar = params["topChar#{index + 1}"]
          lchar = params["bottomChar#{index + 1}"]
          winner = Player.find_by(gamertag: params[:topPlayer])
          loser = Player.find_by(gamertag: params[:bottomPlayer])
          match.update(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
        else
          wchar = params["bottomChar#{index + 1}"]
          lchar = params["topChar#{index + 1}"]
          winner = Player.find_by(gamertag: params[:bottomPlayer])
          loser = Player.find_by(gamertag: params[:topPlayer])
          match.update(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
        end
      end
      redirect_to tournament_path @gameset.tournament
    else
      render 'edit'
    end
  end

end
