class GamesetsController < ApplicationController
  include GamesetsHelper
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
    valid = true

    if validateSet

      puts "DATA:"
      params[:matches].each do |match|
        tplayerScore += 1 if match[:topPlayer].eql?("Win")
        bplayerScore += 1 if match[:bottomPlayer].eql?("Win")
        puts match[:topPlayer]
        puts match[:bottomPlayer]
      end
      if tplayerScore > bplayerScore
        winner = Player.find_by(gamertag: params[:topPlayer])
        loser = Player.find_by(gamertag: params[:bottomPlayer])
        wscore = tplayerScore
        lscore = bplayerScore
      elsif tplayerScore < bplayerScore
        loser = Player.find_by(gamertag: params[:topPlayer])
        winner = Player.find_by(gamertag: params[:bottomPlayer])
        wscore = bplayerScore
        lscore = tplayerScore
      else
        valid = false
        flash[:error] = "Winner could not be determined."
      end
      puts "DATA:"
      puts tplayerScore
      puts bplayerScore

      if @gameset.winner != winner && @gameset.tournament.isIntegration
        valid = false
        flash[:error] = "This tournament is locked you can not switch the winner of any set."
      end

      if valid
        @gameset.update(wscore: wscore, lscore: lscore, winner: winner, loser: loser)
        puts @gameset.inspect
        @gameset.gamematches.each do |match|
          match.destroy
        end
        params[:matches].each_with_index do |m, index|
          matchnum = index + 1
          wchar = ""
          lchar = ""
          winner = Player
          loser = Player
          map = m[:map]
          match = Gamematch
          if m[:topPlayer].eql?("Win")
            wchar = m[:topChar]
            lchar = m[:bottomChar]
            winner = Player.find_by(gamertag: params[:topPlayer])
            loser = Player.find_by(gamertag: params[:bottomPlayer])
            match = Gamematch.create(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
          else
            wchar = m[:bottomChar]
            lchar = m[:topChar]
            winner = Player.find_by(gamertag: params[:bottomPlayer])
            loser = Player.find_by(gamertag: params[:topPlayer])
            match = Gamematch.create(matchnum: matchnum, winner: winner, wchar: wchar, loser: loser, lchar: lchar, gameset_id: @gameset.id, map: map, invalidMatch: false, tournament_id: @gameset.tournament.id)
          end
          match.save
        end
        updateBracket @gameset if @gameset.roundnum != @gameset.tournament.winnersRounds && !@gameset.tournament.isIntegration
      end
      sets = getUpdatedSets(params[:time].to_i, @gameset)
      setArray = Array.new
      sets.each do |set|
        hash = {}
        hash[:id] = set.id
        !set.topPlayer.nil? ? hash[:topPlayer] = set.topPlayer.gamertag : hash[:topPlayer] = ""
        !set.bottomPlayer.nil? ? hash[:bottomPlayer] = set.bottomPlayer.gamertag : hash[:bottomPlayer] = ""
        !set.wscore.nil? ? hash[:wscore] = set.wscore : hash[:wscore] = ""
        !set.lscore.nil? ? hash[:lscore] = set.lscore : hash[:lscore] = ""
        !set.winner.nil? ? hash[:winner] = set.winner.gamertag : hash[:winner] = ""
        !set.loser.nil? ? hash[:loser] = set.loser.gamertag : hash[:loser] = ""

        wchar = []
        lchar = []
        set.gamematches.each do |match|
          if match.winner == set.winner
            wchar.push(match.wchar) if !wchar.include?(match.wchar)
          else
            wchar.push(match.lchar) if !wchar.include?(match.lchar)
          end
          if match.loser == set.loser
            lchar.push(match.lchar) if !lchar.include?(match.lchar)
          else
            lchar.push(match.wchar) if !lchar.include?(match.wchar)
          end
        end

        !wchar.blank? ? hash[:wchar] = wchar : hash[:wchar] = "unknown"
        !lchar.blank? ? hash[:lchar] = lchar : hash[:lchar] = "unknown"
        setArray.push(hash)
      end
      respond_to do |format|
        format.json { render json: setArray.to_json, status: :created }
      end
    end
  end

  def updateBracket set
    tsize = (2 ** (Math.log(set.tournament.players.size, 2).ceil))
    tdetermine = tsize * 0.75
    lessthan = false
    tdetermine >= set.tournament.players.size ? lessthan = true : lessthan = false

    if lessthan
      if set.roundnum > 0
        if set.roundnum == 1
          set.toWinnerSet.bottomPlayer = set.winner
          set.toLoserSet.topPlayer = set.loser
        elsif set.roundnum == 2
          set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : set.toWinnerSet.topPlayer = set.winner
          set.toLoserSet.bottomPlayer = set.loser
        else
          set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : set.toWinnerSet.topPlayer = set.winner if set.roundnum < set.tournament.winnersRounds - 1
          set.toLoserSet.topPlayer = set.loser if set.roundnum < set.tournament.winnersRounds - 1
        end
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
        (set.roundnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : (set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.winner : set.toWinnerSet.topPlayer = set.winner)) if set.roundnum > -set.tournament.losersRounds
        (set.toWinnerSet.bottomPlayer = set.winner) if set.roundnum == -set.tournament.losersRounds
        set.toWinnerSet.save if !set.toWinnerSet.nil?
      end
      updateByes set.toLoserSet if set.roundnum == 2
    else
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
      updateByes set.toLoserSet if set.roundnum == 1
    end
  end

  def validateSet
    top = Player.find_by(gamertag: params[:topPlayer])
    bot = Player.find_by(gamertag: params[:bottomPlayer])
    valid = true
    if @gameset.tournament.id != request.referer.to_s.split('/').last.to_i
      flash[:error] = " Set not a part of this tournament,"
      valid = false;
    end
    if @gameset.nil?
      flash[:error] = " Set not valid,"
      valid = false
    end
    if @gameset.topPlayer != top || @gameset.bottomPlayer != bot
      flash[:error] = " Id was tampered with,"
      valid = false
    end
    if params[:matchCount].to_i > 7
      flash[:error] = " Match Count greater than 7,"
      valid = false
    end
    if params[:matchCount].to_i < 1
      flash[:error] = " Match Count less than 1,"
      valid = false
    end
    if !params[:matchCount].is_i?
      flash[:error] = " Match Count is not a number,"
      valid = false
    end
    return valid
  end

  def intervalUpdate
    sets = getUpdatedSets(params[:time].to_i, params[:id].to_i)
    setArray = Array.new
    sets.each do |set|
      hash = {}
      hash[:id] = set.id
      !set.topPlayer.nil? ? hash[:topPlayer] = set.topPlayer.gamertag : hash[:topPlayer] = ""
      !set.bottomPlayer.nil? ? hash[:bottomPlayer] = set.bottomPlayer.gamertag : hash[:bottomPlayer] = ""
      !set.wscore.nil? ? hash[:wscore] = set.wscore : hash[:wscore] = ""
      !set.lscore.nil? ? hash[:lscore] = set.lscore : hash[:lscore] = ""
      !set.winner.nil? ? hash[:winner] = set.winner.gamertag : hash[:winner] = ""
      !set.loser.nil? ? hash[:loser] = set.loser.gamertag : hash[:loser] = ""

      wchar = []
      lchar = []
      set.gamematches.each do |match|
        if match.winner == set.winner
          wchar.push(match.wchar) if !wchar.include?(match.wchar)
        else
          wchar.push(match.lchar) if !wchar.include?(match.lchar)
        end
        if match.loser == set.loser
          lchar.push(match.lchar) if !lchar.include?(match.lchar)
        else
          lchar.push(match.wchar) if !lchar.include?(match.wchar)
        end
      end

      !wchar.blank? ? hash[:wchar] = wchar : hash[:wchar] = "unknown"
      !lchar.blank? ? hash[:lchar] = lchar : hash[:lchar] = "unknown"
      setArray.push(hash)
    end
    respond_to do |format|
      format.json { render json: setArray.to_json, status: :created }
    end
  end
end
