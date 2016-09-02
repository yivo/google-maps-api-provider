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
          script.crossOrigin = 'anonymous'

          # Start API load
          head.appendChild(script)
          @loading = yes
    return

# @include simplemaps.coffee

GoogleMapsAPI
