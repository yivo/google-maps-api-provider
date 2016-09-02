((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self isnt null and self.self is self
    self

  # Server
  else if typeof global is 'object' and global isnt null and global.global is global
    global

  # AMD
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    root.GoogleMapsAPI = factory(root, document, Date)
    define -> root.GoogleMapsAPI

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(root, document, Date)

  # Browser and the rest
  else
    root.GoogleMapsAPI = factory(root, document, Date)

  # No return value
  return

)((__root__, document, Date) ->
  GoogleMapsAPI =
  
    loaded:  no
    loading: no
    queue:   []
  
    dispatch: ->
      fn() while (fn = @queue.shift())?
      return
  
    callback:
      name: "__#{Date.now?() or +new Date()}GoogleMapsCallback"
      fn: ->
        delete window[GoogleMapsAPI.callback.name]
        GoogleMapsAPI.loaded  = yes
        GoogleMapsAPI.loading = no
        GoogleMapsAPI.dispatch()
        return
  
    load: (callback) ->
      if @loaded
        callback()
  
      else
        @queue.push(callback)
  
        unless @loading
          if (head = document.getElementsByTagName('head')[0])?
            for el in head.getElementsByTagName('meta')
              if el.getAttribute('name') is 'google_api:browser_key'
                key = el.getAttribute('content')
                break
  
            # Prepare API load callback
            __root__[@callback.name] = @callback.fn
  
            # Prepare API params
            query  = "v=3&callback=#{@callback.name}"
            query += "&key=#{key}" if key
  
            # Prepare script tag
            script             = document.createElement('script')
            script.type        = 'text/javascript'
            script.src         = "https://maps.googleapis.com/maps/api/js?#{query}"
            script.crossOrigin = ''
  
            # Start API load
            head.appendChild(script)
            @loading = yes
      return
  
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
  
  GoogleMapsAPI
)