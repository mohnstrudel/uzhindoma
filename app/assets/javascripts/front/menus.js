// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/



//to top function
jQuery(document).on('scroll', function() {
  if (jQuery('body').scrollTop() > 100) {
    jQuery('#on-top').fadeIn('fast');
  }else{
    jQuery('#on-top').fadeOut('fast');
  }
});
jQuery('#on-top').on('click', function(e){
  e.preventDefault();
  $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
})



$(document).ready(function() {

  $('#myTabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')

    var tab_id = $(this).attr('data-tab');

    console.log("Tab id is: " + tab_id);
  });

  // functions to pick dish

  // Выбор кол-ва ужинов на первом табе
  // Все 5 ужинов
  jQuery('#radio1-0').on('change', function(){
    jQuery('.item').eq(3).removeClass('disabled');
    jQuery('.item').eq(4).removeClass('disabled');
  });

  // Таб 1 - Выбор четырех ужинов. При этом десерт не должен меняться
  jQuery('#radio2-0').on('change', function(){
    jQuery('.item').eq(3).removeClass('disabled');
    jQuery('.item').eq(4).addClass('disabled');
  });

  // Таб 1 - Выбор трех ужинов. При этом десерт не должен меняться
    jQuery('#radio3-0').on('change', function(){
    jQuery('.item').eq(3).addClass('disabled');
    jQuery('.item').eq(4).addClass('disabled');
  });

  // Выбор кол-ва ужинов на втором табе
  jQuery('#radio1-1').on('change', function(){
    jQuery('.item').eq(9).removeClass('disabled');
    jQuery('.item').eq(10).removeClass('disabled');
  });

  // Таб 2 - Выбор четырех ужинов. При этом десерт не должен меняться
  jQuery('#radio2-1').on('change', function(){
    jQuery('.item').eq(9).removeClass('disabled');
    jQuery('.item').eq(10).addClass('disabled');
  });

  // Таб 2 - Выбор трех ужинов. При этом десерт не должен меняться
    jQuery('#radio3-1').on('change', function(){
    jQuery('.item').eq(9).addClass('disabled');
    jQuery('.item').eq(10).addClass('disabled');
  });

// Add dessert on first tab
  jQuery('#radio8-0').on('change', function(){
    // console.log("Dessert added first tab!");
    jQuery('.item').eq(5).removeClass('disabled');
  });

// Remove dessert on first tab
  $('#radio9-0').on('change', function(){
    // console.log("Dessert removed first tab!");
    $('.item').eq(5).addClass('disabled');
  });

  // Add dessert on second tab

  $('#radio8-1').on('change', function(){
    $('.item').eq(11).removeClass('disabled');
  });

  // Remove dessert on second tab

  $('#radio9-1').on('change', function(){
    $jQuery('.item').eq(11).addClass('disabled');
  });

	$('[href="#tab-2"]').click(function(){
    	var $item=$('.item');
  		
  		$('.isotope').isotope({ //triggering isotope
                    itemSelector: '.item'
                });
  		$('.isotope').isotope('destroy'); //destroying isotope
  		$('.isotope').isotope();
  		
    	$("#owl-gal-2").owlCarousel({
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

