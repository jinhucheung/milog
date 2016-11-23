post = ()->
  $.ajax {
    url: '/holds?by=' + window.page,
    type: 'PATCH',
    data: { hold: { 
                    content:      $('#editor').val(),
                    title:        $('#title-input').val(),
                    category_id:  $('#post-selected-category-input').val(),
                    tagstr:       $('#tag-input').val(),
                    holdable_id:  $('#article-id').html()
                  } 
          },
    success: (data)->
      #console.log data
      return false
  }

if window.interval == null
  window.interval = setInterval post, 5000
