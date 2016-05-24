if $?
  do ->
    $find = -> $('.js-google-simplemap')

    initialize = ->
      $maps = $find()
      if $maps[0]?
        GoogleMapsAPI.load ->
          $maps = $find()
          return unless $maps[0]?
          $maps.each ->
            $map   = $(this)
            center = new google.maps.LatLng($map.data('lat'), $map.data('lng'))
            zoom   = $map.data('zoom') or 17
            map    = new google.maps.Map(this, {center, zoom, scrollwheel: no, draggable: !isMobile?.any})
            marker = new google.maps.Marker {position: center, map, animation: google.maps.Animation.BOUNCE}
      return

    if Turbolinks?
      if Turbolinks.supported
        $(document).on('page:change', initialize)
      else
        $(initialize)
    else
      $(document).on('ready pjax:end', initialize)