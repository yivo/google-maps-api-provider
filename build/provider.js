(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      root.GoogleMapsAPI = factory(root, document);
      define(function() {
        return root.GoogleMapsAPI;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root, document);
    } else {
      root.GoogleMapsAPI = factory(root, document);
    }
  })(function(__root__, document) {
    var GoogleMapsAPI;
    GoogleMapsAPI = {
      VERSION: '1.0.6',
      loaded: false,
      loading: false,
      queue: [],
      dispatch: function() {
        var fn;
        while ((fn = this.queue.shift()) != null) {
          fn();
        }
        return this;
      },
      callback: {
        name: 'googleMapsAPICallback',
        func: function() {
          delete __root__[GoogleMapsAPI.callback.name];
          GoogleMapsAPI.loaded = true;
          GoogleMapsAPI.loading = false;
          return GoogleMapsAPI.dispatch();
        }
      },
      load: function(callback) {
        var el, head, i, key, len, query, ref, script;
        if (this.loaded) {
          if (typeof callback === "function") {
            callback();
          }
        } else {
          if (callback != null) {
            this.queue.push(callback);
          }
          if (!this.loading) {
            if ((head = document.getElementsByTagName('head')[0]) != null) {
              ref = head.getElementsByTagName('meta');
              for (i = 0, len = ref.length; i < len; i++) {
                el = ref[i];
                if (el.getAttribute('name') === 'google_api:browser_key') {
                  key = el.getAttribute('content');
                  break;
                }
              }
              __root__[this.callback.name] = this.callback.func;
              query = "v=3&callback=" + this.callback.name;
              if (key) {
                query += "&key=" + key;
              }
              script = document.createElement('script');
              script.type = 'text/javascript';
              script.src = "https://maps.googleapis.com/maps/api/js?" + query;
              head.appendChild(script);
              this.loading = true;
            }
          }
        }
        return this;
      }
    };
    return GoogleMapsAPI;
  });

}).call(this);
