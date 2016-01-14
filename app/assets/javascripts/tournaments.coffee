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
              <div class=\"match-player Win\">
                <span>" + div.find(".Win").first().text() + "</span>
                <span class=\"set-character left\">
                  <img alt=\"Peach\" class=\"charImg\" src=\"/assets/maps/unknown-c3b3146dd682fcb2c5ef80378aa356fb367891f27829067aa7125b020b62db73.png\">
                </span>
              </div>
              <div class=\"match-map\">
                <span class=\"currentMap\"><img alt=\"Unknown\" class=\"charImg\" src=\"/assets/maps/unknown-c3b3146dd682fcb2c5ef80378aa356fb367891f27829067aa7125b020b62db73.png\"></span>
                <div class=\"map-list\">
                  " + div.find(".map-list").first().html() + "
                </div>
              </div>
              <div class=\"match-player Lose\">
                <span class=\"set-character right\">
                  <img alt=\"Fox\" class=\"charImg\" src=\"/assets/maps/unknown-c3b3146dd682fcb2c5ef80378aa356fb367891f27829067aa7125b020b62db73.png\">
                </span>
                <span>" + div.find(".Lose").first().text() + "</span>
              </div>
            </div>";
    div.append(html);

  $(".minus").click ->
    parent = $(this).parent().parent().parent();
    div = parent.find(".set-match-container");
    row = div.find(".match-row");
    if(row.length > 1)
      row.last().remove();

  $(".currentMap").click ->
    $(this).parent().find(".map-list").show();

  $(".selectedMap").click ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currMap");
    console.log(image);
    image.attr("src", $(this).attr("src"));
    console.log($(parent).find(".map-list"));
    $(".map-list").hide();

  $(".currentChar").click ->
    $(this).parent().find(".char-list").show();

  $(".selectedChar").click ->
    parent = $(this).parent().parent();
    image = $(parent).find(".currChar");
    console.log(image);
    image.attr("src", $(this).attr("src"));
    console.log($(parent).find(".char-list"));
    $(".char-list").hide();
