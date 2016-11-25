$(document).on 'click', '#side-nav a', ()->
  $('.list-group-item.active').eq(0).removeClass 'active'
  $(this).addClass 'active'
  return true