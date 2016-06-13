(function() {
  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      root.GoogleMapsAPI = factory(root, document, Date);
      define(function() {
        return root.GoogleMapsAPI;
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root, document, Date);
    } else {
      root.GoogleMapsAPI = factory(root, document, Date);
    }
  })(function(__root__, document, Date) {
    var GoogleMapsAPI;
    GoogleMapsAPI = {
      loaded: false,
      loading: false,
      queue: [],
      dispatch: function() {
        var fn;
        while ((fn = this.queue.shift()) != null) {
          fn();
        }
      },
      callback: {
        name: "__" + ((typeof Date.now === "function" ? Date.now() : void 0) || +new Date()) + "GoogleMapsCallback",
        fn: function() {
          delete window[GoogleMapsAPI.callback.name];
          GoogleMapsAPI.loaded = true;
          GoogleMapsAPI.loading = false;
          GoogleMapsAPI.dispatch();
        }
      },
      load: function(callback) {
        var el, head, i, key, len, query, ref, script;
        if (this.loaded) {
          callback();
        } else {
          this.queue.push(callback);
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
              __root__[this.callback.name] = this.callback.fn;
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
      }
    };
    if (typeof $ !== "undefined" && $ !== null) {
      (function() {
        var $find, initialize;
        $find = function() {
          return $('.js-google-simplemap');
        };
        initialize = function() {
          var $maps;
          $maps = $find();
          if ($maps[0] != null) {
            GoogleMapsAPI.load(function() {
              $maps = $find();
              if ($maps[0] == null) {
                return;
              }
              return $maps.each(function() {
                var $map, center, map, marker, zoom;
                $map = $(this);
                center = new google.maps.LatLng($map.data('lat'), $map.data('lng'));
                zoom = $map.data('zoom') || 17;
                map = new google.maps.Map(this, {
                  center: center,
                  zoom: zoom,
                  scrollwheel: false,
                  draggable: !(typeof isMobile !== "undefined" && isMobile !== null ? isMobile.any : void 0)
                });
                return marker = new google.maps.Marker({
                  position: center,
                  map: map,
                  animation: google.maps.Animation.BOUNCE
                });
              });
            });
          }
        };
        if (typeof Turbolinks !== "undefined" && Turbolinks !== null) {
          if (Turbolinks.supported) {
            return $(document).on('page:change', initialize);
          } else {
            return $(initialize);
          }
        } else {
          return $(document).on('ready pjax:end', initialize);
        }
      })();
    }
    return GoogleMapsAPI;
  });

}).call(this);
