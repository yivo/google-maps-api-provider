GoogleMapsAPI =

  VERSION: '1.0.7'
  
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
            switch el.getAttribute('name')

              # What is a key: http://stackoverflow.com/questions/17715572/google-api-keys-what-is-server-key-and-browser-key
              # To get a key: https://developers.google.com/maps/documentation/javascript/get-api-key#get-an-api-key
              when 'google_api:browser_key'
                key = el.getAttribute('content')
              
              # https://developers.google.com/maps/documentation/javascript/versions
              when 'google_maps_api:version'
                ver = el.getAttribute('content')
                
          # Prepare API load callback
          __root__[@callback.name] = @callback.func

          # Prepare API params
          query  = "v=#{ encodeURIComponent(ver or '3') }"
          query += "&callback=#{ encodeURIComponent(@callback.name) }"
          query += "&key=#{ encodeURIComponent(key) }" if key

          # Prepare script tag
          script       = document.createElement('script')
          script.type  = 'text/javascript'
          script.src   = "https://maps.googleapis.com/maps/api/js?#{query}"
          
          # Set defer & async as Google recommends
          script.defer = true
          script.async = true

          # Start API load
          head.appendChild(script)
          @loading = true
    this

GoogleMapsAPI
