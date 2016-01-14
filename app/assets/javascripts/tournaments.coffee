# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".clickable-row").click ->
    $("[id=" + $(this).data("id") + "]").toggle();

  $(".clickable-set").click ->
    $('.set-information').removeClass("show");
    $("[id=" + $(this).data("id") + "]").toggleClass("show");

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
    div.append(html);

  $(".minus").click ->
    parent = $(this).parent().parent().parent();
    div = parent.find(".set-match-container");
    row = div.find(".match-row");
    if(row.length > 1)
      row.last().remove();

  $(".set-match-container").on "click", ".currentMap", ->
    $(this).parent().find(".map-list").show();

  $(".set-match-container").on "click", ".selectedMap", ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currMap");
    console.log(image);
    image.attr("src", $(this).attr("src"));
    console.log($(parent).find(".map-list"));
    $(".map-list").hide();

  $(".set-match-container").on "click", ".currentChar", ->
    $(this).parent().find(".char-list").show();

  $(".set-match-container").on "click", ".selectedChar", ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currChar");
    console.log(image);
    image.attr("src", $(this).attr("src"));
    console.log($(parent).find(".char-list"));
    $(".char-list").hide();
