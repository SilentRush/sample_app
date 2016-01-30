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
      @gameset.gamematches.each do |match|
        match.destroy
      end
      params[:matchCount].to_i.times do |index|
        matchnum = index + 1
        wchar = ""
        lchar = ""
        winner = Player
        loser = Player
        map = params["map#{index + 1}"]
        match = Gamematch
        if params["topPlayer#{index + 1}"].eql?("Win")
          wchar = params["topChar#{index + 1}"]
          lchar = params["bottomChar#{index + 1}"]
          winner = Player.find_by(gamertag: params[:topPlayer])
          loser = Player.find_by(gamertag: params[:bottomPlayer])
          match = Gamematch.create(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
        else
          wchar = params["bottomChar#{index + 1}"]
          lchar = params["topChar#{index + 1}"]
          winner = Player.find_by(gamertag: params[:bottomPlayer])
          loser = Player.find_by(gamertag: params[:topPlayer])
          match = Gamematch.create(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
        end
        match.save
      end
      updateBracket @gameset if @gameset.roundnum != @gameset.tournament.winnersRounds
      redirect_to tournament_path @gameset.tournament
    else
      render 'edit'
    end
  end

  def updateBracket set
    if set.roundnum > 0
      set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : set.toWinnerSet.topPlayer = set.winner
      (set.setnum % 2 == 0 ? set.toLoserSet.bottomPlayer = set.loser : set.toLoserSet.topPlayer = set.loser) if set.roundnum == 1
      set.toLoserSet.topPlayer = set.loser if set.roundnum != 1 && set.roundnum != set.tournament.winnersRounds - 1
      if set.roundnum == set.tournament.winnersRounds - 1
        if set.winner == set.bottomPlayer
          set.toWinnerSet.topPlayer = set.loser
          set.toWinnerSet.bottomPlayer = set.winner
        else
          set.toWinnerSet.topPlayer = nil
          set.toLoserSet.bottomPlayer = nil
        end
      end
      set.toWinnerSet.save if !set.toWinnerSet.nil?
      set.toLoserSet.save if !set.toLoserSet.nil?
    else
      (set.roundnum % 2 == 0 ? (set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : set.toWinnerSet.topPlayer = set.winner) : set.toWinnerSet.bottomPlayer = set.winner) if set.roundnum > -set.tournament.losersRounds
      (set.toWinnerSet.bottomPlayer = set.winner) if set.roundnum == -set.tournament.losersRounds
      set.toWinnerSet.save if !set.toWinnerSet.nil?
    end

  end

end
