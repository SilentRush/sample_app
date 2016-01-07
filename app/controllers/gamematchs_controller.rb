class GamematchsController < ApplicationController
  def new
  end

  def create
  end

  def batchMatch
    @set = Gameset.find(params[:id])
  end
end
