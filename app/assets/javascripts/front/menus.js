// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/


$('#myTabs a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
});

$(document).ready(function() {

	$('[href="#tab-2"]').click(function(){
    	var $item=$('.item');
  		
  		$('.isotope').isotope({ //triggering isotope
                    itemSelector: '.item'
                });
  		$('.isotope').isotope('destroy'); //destroying isotope
  		$('.isotope').isotope();
  		
    	$("#owl-gal-1").owlCarousel({
    		nav : false,
    		responsive:{
        		0:{
            		items:1
        		},
        		600:{
            		items:1
        		},
        		1000:{
            		items:1
        		}
    		}
    });
    });

    $('[href="#tab-1"]').click(function(){
    	var $item=$('.item');
  		
  		$('.isotope').isotope({ //triggering isotope
                    itemSelector: '.item'
                });
  		$('.isotope').isotope('destroy'); //destroying isotope
  		$('.isotope').isotope();

    	$("#owl-gal-1").owlCarousel({
    		nav : false,
    		responsive:{
        		0:{
            		items:1
        		},
        		600:{
            		items:1
        		},
        		1000:{
            		items:1
        		}
    		}
    });
    });
    $('[href="#tab-0"]').click(function(){
    	var $item=$('.item');
  		
  		$('.isotope').isotope({ //triggering isotope
                    itemSelector: '.item'
                });
  		$('.isotope').isotope('destroy'); //destroying isotope
  		$('.isotope').isotope();
  		
    	$("#owl-gal-0").owlCarousel({
		responsive:{
        	0:{
            	items:1
        	},
        	600:{
            	items:1
        	},
        	1000:{
            	items:1
        	}
    		}
    	});
    }); 
    $('[href="#tab-0"]').click();
    
       

});

