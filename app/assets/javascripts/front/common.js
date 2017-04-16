(function($){
    $(document).ready(function(){

        function showPopup($content){
            $(".g-popup-wrapper").fadeOut(100, function(){
              $content.fadeIn(300);    
            });
        }
        $("#popup-wrapper").on("click", function(e){
            var $popup = $(this);
//            if($(e.target).closest(".g-popup").length > 0) return false;
            if($(e.target).closest(".g-popup").length == 0 || $(e.target).closest(".g-popup__close").length == 1)
                $popup.fadeOut(200, function(){
                    $popup.find(".g-popup__content").html("");    
                });
        });

        $("#menu-button").click(function(){
            $(this).toggleClass("g-menu-button_open");
            $("#menu").fadeToggle(300);
        });
        $("#toggle-form").click(function(){
            $(this).toggleClass("g-footer__title_open");
            $("#footer-form-wrapper").fadeToggle(300);
        });

        $(".g-input").on("focus", function(){
          $(this).removeClass("g-input_error");
        });
        $(".g-input").on("blur", function(){
            var val = $(this).val();
            if(val.length == 0) return;
  
            if($(this).attr("type") == "tel" && val.replace(/\D+/g,"").length < 11)
                $(this).addClass("g-input_error");
                
        });
        
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


        } else if($("body").hasClass("home")){
            $(".js-main-menu").on("click", function(e){
                e.preventDefault();
                var $node = $(this).parents(".g-menu-block");
                if($(this).data("var") == $node.data("view")) return false;
                $node.data("view", $(this).data("var")).find("[data-type]").hide().filter("[data-type='"+$(this).data("var")+"']").fadeIn(500);
                $node.find(".g-menu-toggle__var").removeClass("g-menu-toggle__var_active");
                $(this).addClass("g-menu-toggle__var_active");
                return false;
            });
            var $review_popup = $("#review-popup");
            $review_popup.on("click", function(e){
                e.preventDefault();
                if($(e.target).closest(".g-popup-reviews__content").length > 0) return false;
                $review_popup.fadeOut(200, function(){
                    $review_popup.find("#comments, #likes, #comment-list, #img-block").html("");    
                });
                return false;
            });
            $(".js-review").on("click", function(e){
                e.preventDefault();
                $review_popup.find("#comments").text($(this).find(".g-reviews__comments").text());
                $review_popup.find("#likes").text($(this).find(".g-reviews__likes").text());
                $review_popup.find("#comment-list").append($(this).find(".g-comments").clone());
                $('<img class="g-popup-reviews__img" src="'+ $(this).data("picture") +'">').on("load", function(){
                    $(this).appendTo($review_popup.find("#img-block"));
                });
                $review_popup.fadeIn(300);
                return false;
            });
        } else if($("body").hasClass("dinner")){


            
            $("#menu-form").on("submit", function(e){
                e.preventDefault();
                var error = false,
                    $phone = $(this).find("#phone-input"),
                    val = $phone.val().replace(/\D+/g,""),
                    quantity = 5;
                if(val.length < 11){
                    $phone.addClass("g-input_error");
                    error = true;
                }
                if(!error){
                    showPopup($("#send-popup"));

                    $.ajax({
                      url: "/process_order",
                      type: "GET",
                      data: {phone: val, quantity: quantity },
                      success: function (data) {
                      }
                    });
                }
                
                return false;
            });
            var $menu_node = $(".g-menu-block");
            function calculate(){
                var current_type = $menu_node.data("show"),
                    $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
                    $eat = $current_list.find(".m-menu-items__item[data-product='eat']"),
                    $dessert = $current_list.find(".m-menu-items__item[data-product='dessert']"),
                    quantity = $menu_node.find("input[name=quantity]:checked").val(),
                    people = $menu_node.find("input[name=people]:checked").val(),
                    dessert = $menu_node.find("input[name=dessert]:checked").val(),
                    total_price = 0;
                $eat.removeClass("m-menu-items__item_disabled").each(function(i, el){
                    var $el = $(el);
                    if($el.data("package") > quantity)
                        $el.addClass("m-menu-items__item_disabled");
                    else {
                        total_price += $el.data("price");
                    }
                });
                $dessert.removeClass("m-menu-items__item_disabled");
                if(typeof dessert == 'undefined')
                    $dessert.addClass("m-menu-items__item_disabled");
                else
                    $dessert.each(function(i, el){
                        total_price += $(el).data("price");
                    });
                total_price *= people;
                $menu_node.find("#total_price").text(total_price);
            }
            
            calculate();
            $("input[type='tel']").inputmask("+9 (999) 999-99-99");

            $(".js-main-menu").on("click", function(e){
                e.preventDefault();
                if($(this).data("var") == $menu_node.data("view")) return false;
                $menu_node.data("show", $(this).data("var")).find("[data-type]").hide().filter("[data-type='"+$(this).data("var")+"']").fadeIn(500);
                $menu_node.find(".g-menu-toggle__var").removeClass("g-menu-toggle__var_active");
                $(this).addClass("g-menu-toggle__var_active");
                calculate();
                return false;
            });
            $(".js-menu-input").on("click", calculate);
        }
        
        var rem;
	    var isTablet = window.matchMedia("(max-width: 1024px)");
	    var isMobile = window.matchMedia("(max-width: 650px)");
        var commandSlider,
            partnersSlider,
            chooseSlider,
            chooseSliderSlide,
            partnersSliderSlide,
            commandSliderSlide;
        function mobile(){
            if($("body").hasClass("learn_more")){
                commandSlider = $("#command-slider").bxSlider({
                    adaptiveHeight: true
                });
                partnersSlider = $("#partners-slider").bxSlider({
                    minSlides: 2,
                    maxSlides: 2,
                    moveSlides: 1,
                    auto: true,
                    slideWidth: parseInt(25.5 * rem, 10),
                    slideMargin: parseInt(0.5 * rem, 10),
                    mouseDrag: true
                });
                chooseSlider = $("#choose-slider").bxSlider({
                    minSlides: 1,
                    maxSlides: 1,
                    moveSlides: 1,
                    auto: true,
                    slideWidth: parseInt(50 * rem, 10),
                    slideMargin: parseInt(0.5 * rem, 10),
                    mouseDrag: true
                });   
            } else if($("body").hasClass("dinner")){
                $("#menu-items").mCustomScrollbar({
                  axis:"x",
                  theme:"light-3",
                  advanced:{autoExpandHorizontalScroll:true}
                });
                
            }
        }
        function tablet(){
            if($("body").hasClass("learn_more")){
                commandSlider = $("#command-slider").bxSlider({
                    adaptiveHeight: true
                });
                partnersSlider = $("#partners-slider").bxSlider({
                    minSlides: 3,
                    maxSlides: 3,
                    moveSlides: 1,
                    auto: true,
                    slideWidth: parseInt(25.5 * rem, 10),
                    slideMargin: parseInt(0.5 * rem, 10),
                    mouseDrag: true
                });
                
            }
        }
        function desktop(){
            if($("body").hasClass("learn_more")){
                commandSlider = $("#command-slider").bxSlider({
                    adaptiveHeight: true
                });
                if (window.innerWidth > 1280) {
                    partnersSlider = $("#partners-slider").bxSlider({
                        minSlides: 6,
                        maxSlides: 6,
                        moveSlides: 1,
                        auto: true,
                        slideWidth: parseInt(25.5 * rem, 10),
                        slideMargin: parseInt(0.5 * rem, 10),
                        mouseDrag: true
                    });
                } else {
                    partnersSlider = $("#partners-slider").bxSlider({
                        minSlides: 4,
                        maxSlides: 4,
                        moveSlides: 1,
                        auto: true,
                        slideWidth: parseInt(25.5 * rem, 10),
                        slideMargin: parseInt(0.5 * rem, 10),
                        mouseDrag: true
                    });
                }
            }
        }
        function reset() {
            if(commandSlider){
				commandSliderSlide = commandSlider.getCurrentSlide();
				commandSlider.destroySlider();
			}
        }
        function run() {
			rem = parseFloat(getComputedStyle($("html")[0]).fontSize);
			if (isMobile.matches) {
				mobile();
			} else if (isTablet.matches) {
				tablet();
			} else {
				desktop();
			}
		}
		run();
        $(window).on('resize', function () {
			reset();
			run();
		});
        
    });
})(jQuery)