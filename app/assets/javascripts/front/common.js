(function($){
    $(document).ready(function(){
        $("#menu-button").click(function(){
            $(this).toggleClass("g-menu-button_open");
            $("#menu").fadeToggle(300);
        });
        $("#toggle-form").click(function(){
            $(this).toggleClass("g-footer__title_open");
            $("#footer-form-wrapper").fadeToggle(300);
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