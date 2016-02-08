tournamentVars = {};
$(".query_data.query").ready ->
  $(".datepicker").datepicker();

  $(".query_data.query").on "click", ".currentChar", ->
    $(".map-list").hide();
    $(".char-list").toggle();
    $(".char-list").css("margin-top",-($(".char-list").height()/2));
    tournamentVars.ele = this;

  $(".query_data.query").on "click", ".selectedChar", ->
    image = $(tournamentVars.ele).find(".charfilter");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    char = $(this).attr("alt");
    $(tournamentVars.ele).parent().find("input").attr("value", char);
    $(".char-list").hide();

  $(".query_data.query").on "click", ".currentMap", ->
    $(".map-list").toggle();
    $(".char-list").hide();
    $(".map-list").css("margin-top",-($(".map-list").height()/2));
    tournamentVars.ele = this;

  $(".query_data.query").on "click", ".selectedMap", ->
    image = $(tournamentVars.ele).find(".mapfilter");
    image.attr("src", $(this).attr("src"));
    image.attr("alt", $(this).attr("alt"));
    map = $(this).attr("alt");
    $(tournamentVars.ele).parent().find("input").attr("value", map);
    $(".map-list").hide();
