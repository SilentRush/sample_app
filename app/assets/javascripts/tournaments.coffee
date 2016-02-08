# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
tournamentVars = {};
updateInterval = "";

$ ->
  clearInterval(updateInterval);

$(".tournaments.show").ready ->
  $(".clickable-row").click ->
    $("[id=" + $(this).data("id") + "]").toggle();

  $("#sortable").sortable(  () ->
    stop: (e,ui) ->
  );

  sortrow = () ->
    $(".player-row").each (index,row) ->
      $(row).find(".seed").html(index + 1 + ". ");

  $("#sortable").on("sortstop", (e,ui) ->
    sortrow();
  )

  getcharlist = (char) ->
    char = ["bowser","captainfalcon","dk","drmario","falco","fox","ganondorf","iceclimbers",
            "jigglypuff","kirby","link","luigi","mario","marth","mewtwo","mrgamewatch","ness",
            "peach","pichu","pikachu","roy","samus","sheik","yoshi","younglink","zelda","unknown"];
    return char;

  getmaplist = (map) ->
    map = ["battlefield","dreamland","finaldestination","fountainofdreams","pokemonstadium","yoshistory"];
    return map;

  loadSetInformation = (ele) ->
    $.ajax
      url: "/tournaments/getSetData"
      type: "POST"
      data:
        id: $(ele).data("id");
      success: (data, status, response) ->
        if data.topPlayer_id != null && data.bottomPlayer_id != null
          box = $('.set-information');
          box.find("[name=matchCount]").val(data.matches.length);
          box.find("form").attr("action", "/gamesets/update/" + data.id);
          box.find(".set-player.top span").html("<a class='links' href='../players/" + data.topPlayer_id + "'>" + data.topPlayer.gamertag + "</a>");
          box.find(".set-player.top input").val(data.topPlayer.gamertag);
          box.find(".set-player.bot span").first().html("<a class='links' href='../players/" + data.bottomPlayer_id + "'>" + data.bottomPlayer.gamertag + "</a>");
          box.find(".set-player.bot input").val(data.bottomPlayer.gamertag);
          $('.set-match-container').html("");
          $(data.matches).each (index, match) ->
            matchrow = document.createElement("div");
            matchrow.className = "match-row";
            matchmap = document.createElement("div");
            currmap = document.createElement("span");
            currmapimg = document.createElement("img");
            currmapinput = document.createElement("input");
            maps = getmaplist();
            matchmap.className = "match-map";
            currmap.className = "currentMap";
            currmapimg.className = "currMap";
            currmapinput.type = "hidden";

            currmapinput.setAttribute("name","matches[][map]");
            if $.inArray(match.map, maps) == -1
              $(currmapinput).val("unknown");
              currmapimg.src = "/assets/maps/unknown.png";
            else
              $(currmapinput).val(match.map);
              currmapimg.src = "/assets/maps/" + match.map + ".png";

            $(currmap).append(currmapimg);
            $(matchmap).append(currmap).append(currmapinput);

            matchplayer = document.createElement("div");
            matchplayerspan = document.createElement("span");
            matchplayerinput = document.createElement("input");
            matchcharacter = document.createElement("span");
            currcharacter = document.createElement("span");
            currcharimg = document.createElement("img");
            currcharinput = document.createElement("input");
            currcharinput.type = "hidden";
            chars = getcharlist();
            matchcharacter.className = "set-character left";
            currcharacter.className = "currentChar";
            currcharimg.className = "currChar";
            matchplayerspan.className = "match-playername";
            matchplayerinput.type = "hidden";
            matchplayerinput.setAttribute("name", "matches[][topPlayer]");
            currcharinput.setAttribute("name", "matches[][topChar]");
            if match.winner_id == data.topPlayer_id
              matchplayer.className = "match-player Win";
              $(matchplayerinput).val("Win");
              if $.inArray(match.wchar, chars) == -1
                currcharimg.src = "/assets/characters/unknowncs.png";
                $(currcharinput).val("unknown");
              else
                currcharimg.src = "/assets/characters/"+ match.wchar + "cs.png";
                $(currcharinput).val(match.wchar);
            else
              matchplayer.className = "match-player Lose";
              $(matchplayerinput).val("Lose");
              if $.inArray(match.lchar, chars) == -1
                currcharimg.src = "/assets/characters/unknowncs.png";
                $(currcharinput).val("unknown");
              else
                currcharimg.src = "/assets/characters/"+ match.lchar + "cs.png";
                $(currcharinput).val(match.lchar);

            $(currcharacter).append(currcharimg);
            $(matchcharacter).append(currcharacter).append(currcharinput);
            $(matchplayerspan).html(data.topPlayer.gamertag);
            $(matchplayer).append(matchplayerspan).append(matchplayerinput);

            $(matchrow).append(matchplayer).append(matchcharacter).append(matchmap);


            matchplayer = document.createElement("div");
            matchplayerspan = document.createElement("span");
            matchplayerinput = document.createElement("input");
            matchcharacter = document.createElement("span");
            currcharacter = document.createElement("span");
            currcharimg = document.createElement("img");
            currcharinput = document.createElement("input");
            currcharinput.type = "hidden";
            chars = getcharlist();
            matchcharacter.className = "set-character right";
            currcharacter.className = "currentChar";
            currcharimg.className = "currChar";
            matchplayerspan.className = "match-playername";
            matchplayerinput.type = "hidden";
            matchplayerinput.setAttribute("name", "matches[][bottomPlayer]");
            currcharinput.setAttribute("name", "matches[][bottomChar]");
            if match.winner_id == data.bottomPlayer_id
              matchplayer.className = "match-player Win";
              $(matchplayerinput).val("Win");
              if $.inArray(match.wchar, chars) == -1
                currcharimg.src = "/assets/characters/unknowncs.png";
                $(currcharinput).val("unknown");
              else
                currcharimg.src = "/assets/characters/"+ match.wchar + "cs.png";
                $(currcharinput).val(match.wchar);
            else
              matchplayer.className = "match-player Lose";
              $(matchplayerinput).val("Lose");
              if $.inArray(match.lchar, chars) == -1
                currcharimg.src = "/assets/characters/unknowncs.png";
                $(currcharinput).val("unknown");
              else
                currcharimg.src = "/assets/characters/"+ match.lchar + "cs.png";
                $(currcharinput).val(match.lchar);

            $(currcharacter).append(currcharimg);
            $(matchcharacter).append(currcharacter).append(currcharinput);
            $(matchplayerspan).html(data.bottomPlayer.gamertag);
            $(matchplayer).append(matchplayerspan).append(matchplayerinput);
            $(matchrow).append(matchcharacter).append(matchplayer);

            $('.set-match-container').append(matchrow);
          box.find("#url-link").attr("href","/gamesets/" + data.id);
          box.toggleClass("show");
          box.css("margin-top",-(box.height()/2));
      error: ->
        $('#results').html("ERROR");

  updateSet = (ele) ->
    div = $("div").find("[data-id='" + ele.id + "']");
    top = div.find(".match_top_half");
    bot = div.find(".match_bottom_half");
    topPlayer = top.find("span");
    botPlayer = bot.find("span");
    topScore = top.find(".top_score");
    botScore = bot.find(".bottom_score");
    topChar = top.find(".inner_content");
    botChar = bot.find(".inner_content");
    topChar.find("img").remove();
    botChar.find("img").remove();
    $(topPlayer).text(ele.topPlayer);
    $(botPlayer).text(ele.bottomPlayer);
    if ele.topPlayer == ele.winner && ele.winner != ""
      $(topScore).html(ele.wscore);
      $(topScore).addClass("winner");
      $(botScore).html(ele.lscore);
      $(botScore).removeClass("winner");
      $(ele.wchar).each (index, char) ->
        img = document.createElement("img");
        if char == "" then char = "unknown"
        $(img).attr("src","/assets/characters/" + char + "-icon.png");
        $(img).attr("alt",char);
        $(img).attr("class","bracket-charImg");
        $(topChar).append(img);
      $(ele.lchar).each (index, char) ->
        img = document.createElement("img");
        if char == "" then char = "unknown"
        $(img).attr("src","/assets/characters/" + char + "-icon.png");
        $(img).attr("alt",char);
        $(img).attr("class","bracket-charImg");
        $(botChar).append(img);
    else
      $(topScore).html(ele.lscore);
      $(topScore).removeClass("winner");
      $(botScore).html(ele.wscore);
      $(botScore).addClass("winner");
      $(ele.wchar).each (index, char) ->
        img = document.createElement("img");
        if char == "" then char = "unknown"
        $(img).attr("src","/assets/characters/" + char + "-icon.png");
        $(img).attr("alt",char);
        $(img).attr("class","bracket-charImg");
        $(botChar).append(img);
      $(ele.lchar).each (index, char) ->
        img = document.createElement("img");
        if char == "" then char = "unknown"
        $(img).attr("src","/assets/characters/" + char + "-icon.png");
        $(img).attr("alt",char);
        $(img).attr("class","bracket-charImg");
        $(topChar).append(img);

  updateWatcher = ->
    updateInterval = setInterval ->
      checkForUpdate();
      date = new Date();
      $('[name=time]').val(date);
    , 30000

  checkForUpdate = ->
    date = new Date($('[name=time]').val());
    $.ajax
      url: "/gamesets/intervalUpdate"
      type: "POST"
      data:
        id: $('[name=id]').val();
        time: date.getTime()
      success: (data, status, response) ->
        $(data).each (index, set) ->
          updateSet(set);
      error: ->
        $('#player-errors').html("ERROR");

  updateWatcher();

  $('#setform').submit (e) ->
    e.preventDefault();
    data = $('#setform').serializeArray();
    date = new Date();
    newdate = new Date(date.getTime() - 3*60000);
    data[data.length] = { name: "time", value: newdate.getTime()};
    $.ajax
      url: $(this).attr("action")
      type: "POST"
      data: data
      success: (data, status, response) ->
        $(data).each (index, set) ->
          updateSet(set);
        $(".set-information").fadeOut ->
          $(this).removeClass("show");
      error: ->
        $('#player-errors').html("ERROR");

  $(".clickable-set").click ->
    if $(".set-information").hasClass("show")
      $('.set-information').fadeOut ->
        $(".set-information").removeClass("show");
    else
      loadSetInformation(this);

  $(".set-information-close").click ->
    $('.set-information').fadeOut ->
      $('.set-information').removeClass("show");
    $('.map-list').fadeOut ->
      $('.map-list').hide();
    $('.char-list').fadeOut ->
      $('.char-list').hide();

  $('.tabs .tab-links a').on 'click', (event) ->
    currentAttrValue = $(this).attr('href');
    $('.tabs ' + currentAttrValue).show().siblings().hide();
    $(this).parent('li').addClass('active').siblings().removeClass('active');
    event.preventDefault();

  $(".set-information").on "click", "#create-url", ->
    $(".create-url").toggle();

  $(".set-information").on "click", ".plus", ->
    parent = $(".set-information");
    id = parent.find(".match-row").length + 1;
    div = parent.find(".set-match-container");
    html = "<div class=\"match-row\">
              " + div.find(".match-row").html() + "
            </div>";
    if(id < 8)
      div.append(html);
      newRow = div.find(".match-row").last();
      parent.find("[name=matchCount]").attr("value", id);

  $(".set-information").on "click", ".minus", ->
    parent = $(".set-information");
    div = parent.find(".set-match-container");
    row = div.find(".match-row");
    if(row.length > 1)
      row.last().remove();
    id = parent.find(".match-row").length;
    parent.find("[name=matchCount]").attr("value", id);

  $(".set-match-container").on "click", ".currentMap", ->
    $(".map-list").show();
    $(".map-list").css("margin-top",-($(".map-list").height()/2));
    tournamentVars.ele = this;

  $(".set-information").on "click", ".selectedMap", ->
    image = $(tournamentVars.ele).find(".currMap");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    map = $(this).attr("alt");
    $(tournamentVars.ele).parent().find("input").attr("value", map);
    $(".map-list").hide();


  $(".set-match-container").on "click", ".currentChar", ->
    $(".char-list").show();
    $(".char-list").css("margin-top",-($(".char-list").height()/2));
    tournamentVars.ele = this;

  $(".set-information").on "click", ".selectedChar", ->
    image = $(tournamentVars.ele).find(".currChar");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    char = $(this).attr("alt");
    $(tournamentVars.ele).parent().find("input").attr("value", char);
    $(".char-list").hide();

  $(".set-match-container").on "click", ".match-player", ->
    parent = $(this).parent();
    win = $(this);
    lose = parent.find(".match-player");
    lose.removeClass("Win");
    win.removeClass("Lose");
    win.toggleClass("Win");
    lose.find("input").attr("value", "Lose");
    win.find("input").attr("value", "Win");

  $("#url-link").hover ->
    #$(this).find("img").attr("src","/assets/youtubehover.png");

$(".tournaments.new").ready ->
  $('.createPlayer').click ->
    $.ajax
      url: "/players/new"
      type: "POST"
      data:
        gamertag: $('#search').val();
      success: (data, status, response) ->
        if data.id == null
          $('#player-errors').html(data.error);
          $('#search').css({"outline":"none","border-color":"#FF3B3B","box-shadow":"0 0 10px #FF3B3B"});
        else
          $('#search').css("");
          $('#id').val(data.id);
          $(".addPlayer").click();
      error: ->
        $('#player-errors').html("ERROR");

  $("#search").on('keypress', ((e) ->
    if e.keyCode == 13
      $(".addPlayer").click();
  ).bind(this))

  $(".addPlayer").click ->
    gamertag = $('#search')
    id = $('[name=id]');
    if(id.val() != "")
      row = document.createElement("div");
      row.className = "player-row";
      seed = document.createElement("span");
      seed.className = "seed";
      span = document.createElement("span");
      delBtn = document.createElement("span");
      delBtn.className = "delBtn glyphicon glyphicon-remove";
      span.innerHTML = gamertag.val();
      idInput = document.createElement("input");
      idInput.setAttribute("name", "player[][id]");
      idInput.type = "hidden";
      idInput.value = id.val();
      $(row).append(seed);
      $(row).append(span);
      $(row).append(idInput);
      $(row).append(delBtn);
      $('.player-list-table').append(row);
      $('.player-errors').html("");
      $('#search').val("");
      sortrow();
    else
      $('.player-errors').html(gamertag.val() + " is not a valid player!");
      $('.player-errors').css({"color":"red"});

  $(".player-container-list").on "click", ".delBtn", ->
    $(this).parent(".player-row").fadeOut(() ->
      $(this).remove();
      sortrow();
    )
