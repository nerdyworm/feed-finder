$(function() {

  var $form = $("#form"),
      $feed = $("#feed_url"),
      $url  = $("#url");

  $form.submit(function(event) {
    loading();

    var data = {
      feed: {
        url: $url.attr('value')
      }
    };

    $.ajax({type: 'POST', url:'/feed.json', data:data, 
      success:function(d) {
        $feed.html(d.feed_url).hide().fadeIn('slow');
      },
      error:function(e) {
        $feed.html("There was an error, please check your url").fadeIn();
      }
    });

    event.preventDefault();
    return false;
  });

  function loading() {
    $feed.html('<img src="/img/ajax-loader.gif" alt="loading"/>');
  }
});
