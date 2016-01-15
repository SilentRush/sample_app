class MeleeCharacter
  def initialize(charNum)
    @charnum = charNum
  end

  def get_character
    case @charnum
    when "1.png"
      return "bowser"
    when "2.png"
      return "captainfalcon"
    when "3.png"
      return "dk"
    when "4.png"
      return "drmario"
    when "5.png"
      return "falco"
    when "6.png"
      return "fox"
    when "7.png"
      return "ganondorf"
    when "8.png"
      return "iceclimbers"
    when "9.png"
      return "jigglypuff"
    when "10.png"
      return "kirby"
    when "11.png"
      return "link"
    when "12.png"
      return "luigi"
    when "13.png"
      return "mario"
    when "14.png"
      return "marth"
    when "15.png"
      return "mewtwo"
    when "16.png"
      return "mrgamewatch"
    when "17.png"
      return "ness"
    when "18.png"
      return "peach"
    when "19.png"
      return "pichu"
    when "20.png"
      return "pikachu"
    when "21.png"
      return "roy"
    when "22.png"
      return "samus"
    when "23.png"
      return "sheik"
    when "24.png"
      return "yoshi"
    when "25.png"
      return "younglink"
    when "26.png"
      return "zelda"
    else
      return "unknown"
    end
  end
end
