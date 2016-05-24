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
        __root__[@callback.name] = @callback.fn
        if (head = document.getElementsByTagName('head')[0])?
          script      = document.createElement('script')
          script.type = 'text/javascript'
          script.src  = "http://maps.googleapis.com/maps/api/js?v=3&callback=#{@callback.name}"
          head.appendChild(script)
          @loading = yes
    return

# @include simplemaps.coffee

GoogleMapsAPI