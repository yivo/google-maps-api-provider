((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self isnt null and self.self is self
    self

  # Server
  else if typeof global is 'object' and global isnt null and global.global is global
    global

  # AMD
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    root.GoogleMapsAPI = factory(root, document)
    define -> root.GoogleMapsAPI

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(root, document)

  # Browser and the rest
  else
    root.GoogleMapsAPI = factory(root, document)

  # No return value
  return

)((__root__, document) ->
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
)