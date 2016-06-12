// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/


	$(".owl-carousel-home").owlCarousel({
 
      autoPlay: 3000, //Set AutoPlay to 3 seconds
 
      items : 3,
      itemsDesktop : [400,3],
      itemsDesktopSmall : [640,1]
	
 
  });	


mapboxgl.accessToken = 'pk.eyJ1Ijoic2NobmliYmEiLCJhIjoiMWEwYWI4YTA3YTAwYjVhYTY1YWZiZGFiZDk1Zjk5NGUifQ.ueMMb8kMdWxrP5N4iqx67Q';
  var map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/dark-v9',
      center: [37.5689484, 55.7491617],
  	  zoom: 8.5,
  	  hash: true,
  	  interactive: false
  });

map.on('load', function () {
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
					[37.57865,55.9117],
					[37.52786,55.90651],
					[37.47158,55.88438],
					[37.44004,55.88246],
					[37.40169,55.86554],
					[37.39089,55.84554],
					[37.39952,55.83562],
					[37.38656,55.80649],
					[37.37437,55.79067],
					[37.36849,55.77119],
					[37.36948,55.75171],
					[37.38694,55.71094],
					[37.41216,55.69228],
					[37.433,55.66262],
					[37.50466,55.59882],
					[37.59375,55.57569],
					[37.67323,55.5712],
					[37.71958,55.5886],
					[37.75734,55.60399],
					[37.7999,55.62777],
					[37.83558,55.6505],
					[37.84103,55.66031],
					[37.8327,55.69508],
					[37.83809,55.72055],
					[37.84065,55.77761],
					[37.83477,55.8252],
					[37.69898,55.89462],
					[37.63873,55.90082]

                    ]]
            }
        }
    });

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
  });

