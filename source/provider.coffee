GoogleMapsAPI =

  VERSION: '1.0.6'
  
  loaded:  false
  loading: false
  queue:   []

  dispatch: ->
    fn() while (fn = @queue.shift())?
    this
    
  callback:
    name: 'googleMapsAPICallback'
    func: ->
      delete __root__[GoogleMapsAPI.callback.name]
      GoogleMapsAPI.loaded  = true
      GoogleMapsAPI.loading = false
      GoogleMapsAPI.dispatch()

  load: (callback) ->
    if @loaded
      callback?()

    else
      @queue.push(callback) if callback?

      unless @loading
        if (head = document.getElementsByTagName('head')[0])?
          for el in head.getElementsByTagName('meta')
            if el.getAttribute('name') is 'google_api:browser_key'
              key = el.getAttribute('content')
              break

          # Prepare API load callback
          __root__[@callback.name] = @callback.func

          # Prepare API params
          query  = "v=3&callback=#{@callback.name}"
          query += "&key=#{key}" if key

          # Prepare script tag
          script      = document.createElement('script')
          script.type = 'text/javascript'
          script.src  = "https://maps.googleapis.com/maps/api/js?#{query}"

          # Start API load
          head.appendChild(script)
          @loading = true
    this

GoogleMapsAPI
