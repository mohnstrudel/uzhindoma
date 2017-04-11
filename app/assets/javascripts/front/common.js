(function($){
    $(document).ready(function(){
        if($("body").hasClass("learn_more")){
            mapboxgl.accessToken = 'pk.eyJ1Ijoic2NobmliYmEiLCJhIjoiMWEwYWI4YTA3YTAwYjVhYTY1YWZiZGFiZDk1Zjk5NGUifQ.ueMMb8kMdWxrP5N4iqx67Q';
            var map = new mapboxgl.Map({
                container: 'h-map',
                style: 'mapbox://styles/schnibba/ciw9f6qp500542qmkzdjjqd8o',
                center: [37.5689484, 55.7491617],
                zoom: 7.5,
                hash: false,
                interactive: false
            });

            var nav = new mapboxgl.NavigationControl();
            // Add zoom and rotation controls to the map.
            map.on('load', function () {
              map.addControl(nav, 'top-left');
              map.dragPan.enable();

              map.addSource('maine', {
                'type': 'geojson',
                'data': {
                    'type': 'Feature',
                    'properties': {
                        'name': 'Maine'
                    },
                    'geometry': {
                        'type': 'Polygon',
                        'coordinates': [[

                          [36.95821, 55.514  ],
                          [36.97789, 55.5061 ], 
                          [37.04059, 55.50896],
                          [37.28173, 55.4355 ], 
                          [37.44936, 55.31938], 
                          [37.34918, 55.13644], 
                          [37.43796, 55.10902], 
                          [37.65583, 55.13168], 
                          [37.67015, 55.3328 ], 
                          [37.79473, 55.34216], 
                          [37.86232, 55.31259], 
                          [37.99739, 55.36467], 
                          [38.12697, 55.51639], 
                          [38.13084, 55.55239], 
                          [38.28868, 55.52922], 
                          [38.27275, 55.5927 ], 
                          [38.21414, 55.6433 ], 
                          [38.14215, 55.67443], 
                          [38.13597, 55.7094 ], 
                          [38.15138, 55.7617 ], 
                          [38.22328, 55.8059 ], 
                          [38.23201, 55.84693], 
                          [38.23912, 55.86513], 
                          [38.2215,  55.88565], 
                          [38.06694, 55.95804], 
                          [37.97071, 55.99522], 
                          [37.98579, 56.02405], 
                          [37.88772, 56.0356 ], 
                          [37.75709, 56.0448 ], 
                          [37.6213,  56.11531], 
                          [37.55264, 56.13215], 
                          [37.51762, 56.14707], 
                          [37.5135,  56.17575], 
                          [37.4826,  56.17919], 
                          [37.46955, 56.1597 ], 
                          [37.37434, 56.09336], 
                          [37.15005, 56.04519], 
                          [37.07864, 55.98991], 
                          [37.02164, 55.89799], 
                          [36.93509, 55.88116], 
                          [36.92122, 55.84401], 
                          [36.89867, 55.84241], 
                          [36.89787, 55.82444], 
                          [36.91663, 55.82221], 
                          [36.91455, 55.74021], 
                          [36.97404, 55.67989], 
                          [36.96593, 55.66421], 
                          [36.95852, 55.62993],
                          [36.96041, 55.58009], 
                          [36.96325, 55.52501]

                        ]]
                      }
                  }
              });

              // Painting
              map.addLayer({
                'id': 'route',
                'type': 'fill',
                'source': 'maine',
                'layout': {},
                'paint': {
                    'fill-color': '#088',
                    'fill-opacity': 0.8
                  }
              });
              // Those we keep
            });
        }
        
        $(".g-week-menu__var").on("click", function(e){
            e.preventDefault();
            var $node = $(this).parents(".g-week-menu");
            if($(this).data("var") == $node.data("view")) return false;
            $node.data("view", $(this).data("var")).find("[data-type]").hide().filter("[data-type='"+$(this).data("var")+"']").fadeIn(500);
            $node.find(".g-week-menu__var").removeClass("g-week-menu__var_active");
            $(this).addClass("g-week-menu__var_active");
            return false;
        });
        
    });
})(jQuery)