# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.init_lists = ->
    $(".selectionStatus").on "click", ->
        $(this).closest("form").submit()

$ ->
  window.init_lists ->
