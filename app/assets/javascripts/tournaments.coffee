# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".clickable-row").click ->
    $("[id=" + $(this).data("id") + "]").toggle();
    
  $(".clickable-set").click ->
    $("[id=" + $(this).data("id") + "]").toggle();

  $('.tabs .tab-links a').on 'click', (event) ->
    currentAttrValue = $(this).attr('href');
    $('.tabs ' + currentAttrValue).show().siblings().hide();
    $(this).parent('li').addClass('active').siblings().removeClass('active');
    event.preventDefault();
