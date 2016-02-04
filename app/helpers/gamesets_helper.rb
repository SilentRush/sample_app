module GamesetsHelper
  def updateByes set
    tsize = (2 ** (Math.log(set.tournament.players.size, 2).ceil))
    tdetermine = tsize * 0.75
    lessthan = false
    tdetermine >= set.tournament.players.size ? lessthan = true : lessthan = false
    bye = Player.find_by(gamertag: "bye")

    if lessthan
      if set.roundnum == 1
        if !bye.nil?  && (set.topPlayer == bye || set.bottomPlayer == bye)
          if set.topPlayer == bye
            set.toLoserSet.topPlayer = set.topPlayer
            set.toWinnerSet.bottomPlayer = set.bottomPlayer
          else
            set.toLoserSet.topPlayer = set.bottomPlayer
            set.toWinnerSet.bottomPlayer = set.topPlayer
          end
          set.toWinnerSet.save if !set.toWinnerSet.nil?
          set.toLoserSet.save if !set.toLoserSet.nil?
        end
      end
      if set.roundnum == -1
        if !bye.nil?  && (set.topPlayer == bye || set.bottomPlayer == bye)
          if set.topPlayer == bye
            set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.bottomPlayer : set.toWinnerSet.topPlayer = set.bottomPlayer
          else
            set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.topPlayer : set.toWinnerSet.topPlayer = set.topPlayer
          end
          set.toWinnerSet.save if !set.toWinnerSet.nil?
        end
      end
    else
      if set.roundnum == 1
        if !bye.nil?  && (set.topPlayer == bye || set.bottomPlayer == bye)
          if set.topPlayer == bye
            (set.setnum % 2 == 0 ? set.toLoserSet.bottomPlayer = set.topPlayer : set.toLoserSet.topPlayer = set.topPlayer) if set.roundnum == 1
            set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.bottomPlayer : set.toWinnerSet.topPlayer = set.bottomPlayer
          else
            (set.setnum % 2 == 0 ? set.toLoserSet.bottomPlayer = set.bottomPlayer : set.toLoserSet.topPlayer = set.bottomPlayer) if set.roundnum == 1
            set.setnum % 2 == 0 ? set.toWinnerSet.bottomPlayer = set.topPlayer : set.toWinnerSet.topPlayer = set.topPlayer
          end
          set.toWinnerSet.save if !set.toWinnerSet.nil?
          set.toLoserSet.save if !set.toLoserSet.nil?
        end
      end
      if set.roundnum == -1
        if !bye.nil?  && (set.topPlayer == bye || set.bottomPlayer == bye)
          if set.topPlayer == bye
             set.toWinnerSet.bottomPlayer = set.bottomPlayer
          else
            set.toWinnerSet.bottomPlayer = set.topPlayer
          end
          set.toWinnerSet.save if !set.toWinnerSet.nil?
        end
      end
    end
  end

  def getUpdatedSets time, tournament
    sets = Gameset.where("updated_at >= ? AND tournament_id = ?", Time.at(time/1000), tournament)
    return sets
  end
end
