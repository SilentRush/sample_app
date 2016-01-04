class Player
  attr_accessor :gamertag, :name, :characters, :wins, :loses
  attr_reader :winrate
  def initialize gamertag = "", name = "", character = ""
    @name = name
    @gamertag = gamertag
    @characters = Array.new
    @characters.push(character) if !character.blank?
    @wins = 0
    @loses = 0
    @winrate = 0.0
  end

  def addCharacter character
    @characters.push(character)
  end

  def calcWinrate
    @loses == 0 ? @winrate = 1 : @winrate = @wins.to_f / (@wins + @loses).to_f
  end
end
