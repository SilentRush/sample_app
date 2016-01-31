# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".clickable-row").click ->
    $("[id=" + $(this).data("id") + "]").toggle();

  $(".clickable-set").click ->
    $('.set-information').removeClass("show");
    set = $("[id=" + $(this).data("id") + "]")
    if set.find('[name=topPlayer]').val() != "" && set.find('[name=bottomPlayer]').val() != ""
      set.toggleClass("show");

  $(".set-information-close").click ->
    $('.set-information').removeClass("show");

  $('.tabs .tab-links a').on 'click', (event) ->
    currentAttrValue = $(this).attr('href');
    $('.tabs ' + currentAttrValue).show().siblings().hide();
    $(this).parent('li').addClass('active').siblings().removeClass('active');
    event.preventDefault();

  $(".plus").click ->
    parent = $(this).parent().parent().parent();
    id = parent.find(".match-row").length + 1;
    div = parent.find(".set-match-container");
    html = "<div class=\"match-row\">
              " + div.find(".match-row").html() + "
            </div>";
    if(id < 8)
      div.append(html);
      newRow = div.find(".match-row").last();
      newRow.find(".match-player").first().find("input").attr("name","topPlayer" + id);
      newRow.find(".match-player").last().find("input").attr("name","bottomPlayer" + id);
      newRow.find(".set-character").first().find("input").attr("name","topChar" + id);
      newRow.find(".set-character").last().find("input").attr("name","bottomChar" + id);
      newRow.find(".match-map").first().find("input").attr("name","map" + id);
      parent.find("[name=matchCount]").attr("value", id);

  $(".minus").click ->
    parent = $(this).parent().parent().parent();
    div = parent.find(".set-match-container");
    row = div.find(".match-row");
    if(row.length > 1)
      row.last().remove();
    id = parent.find(".match-row").length;
    console.log(id);
    parent.find("[name=matchCount]").attr("value", id);

  $(".set-match-container").on "click", ".currentMap", ->
    $(this).parent().find(".map-list").show();

  $(".set-match-container").on "click", ".selectedMap", ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currMap");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    map = $(this).attr("alt");
    parent.find("input").attr("value", map);
    $(".map-list").hide();


  $(".set-match-container").on "click", ".currentChar", ->
    $(this).parent().find(".char-list").show();

  $(".set-match-container").on "click", ".selectedChar", ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currChar");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    char = $(this).attr("alt");
    parent.find("input").attr("value", char);
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

  $("#search").on('keypress', ((e) ->
    if e.keyCode == 13
      $(".addPlayer").click();
  ).bind(this))

  $(".addPlayer").click ->
    gamertag = $('#search')
    id = $('[name=id]');
    console.log(id.val());
    console.log(gamertag.val());
    if(id.val() != "")
      row = document.createElement("div");
      row.className = "player-row";
      span = document.createElement("span");
      delBtn = document.createElement("span");
      delBtn.className = "delBtn glyphicon glyphicon-remove";
      span.innerHTML = gamertag.val();
      idInput = document.createElement("input");
      idInput.setAttribute("name", gamertag.val());
      idInput.type = "hidden";
      idInput.value = id.val();
      $(row).append(span);
      $(row).append(idInput);
      $(row).append(delBtn);
      $('.player-list-table').append(row);
      $('.player-errors').html("");
      $('#search').val("");
    else
      $('.player-errors').html(gamertag.val() + " is not a valid player!");
      $('.player-errors').css({"color":"red"});

  $(".player-container-list").on "click", ".delBtn", ->
    $(this).parent(".player-row").remove();
