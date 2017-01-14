
/*!
 * google-maps-api-provider 1.0.7 | https://github.com/yivo/google-maps-api-provider | MIT License
 */

(function() {
  (function(factory) {
    var __root__;
    __root__ = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : Function('return this')();
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      __root__.GoogleMapsAPI = factory(__root__, document, encodeURIComponent);
      define(function() {
        return __root__.GoogleMapsAPI;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(__root__, document, encodeURIComponent);
    } else {
      __root__.GoogleMapsAPI = factory(__root__, document, encodeURIComponent);
    }
  })(function(__root__, document, encodeURIComponent) {
    var GoogleMapsAPI;
    GoogleMapsAPI = {
      VERSION: '1.0.7',
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
        var el, head, i, key, len, query, ref, script, ver;
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
                switch (el.getAttribute('name')) {
                  case 'google_api:browser_key':
                    key = el.getAttribute('content');
                    break;
                  case 'google_maps_api:version':
                    ver = el.getAttribute('content');
                }
              }
              __root__[this.callback.name] = this.callback.func;
              query = "v=" + (encodeURIComponent(ver || '3'));
              query += "&callback=" + (encodeURIComponent(this.callback.name));
              if (key) {
                query += "&key=" + (encodeURIComponent(key));
              }
              script = document.createElement('script');
              script.type = 'text/javascript';
              script.src = "https://maps.googleapis.com/maps/api/js?" + query;
              script.defer = true;
              script.async = true;
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
