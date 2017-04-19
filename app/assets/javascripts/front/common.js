(function($){
    function validateEmail(email) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }
    $(document).ready(function(){
      var number_text = ["один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять", "одинадцать", "двенадцать"],
            persons_text = ["одна", "две", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять", "десять", "одинадцать", "двенадцать"],
        all_text = "Все ";
        function showPopup($content){
            $(".g-popup-wrapper").fadeOut(100, function(){
                $content.fadeIn(300);    
            });            
        }
        $(".g-popup-wrapper").on("click", function(e){
            var $popup = $(this);
            if($(e.target).closest(".g-popup").length == 0 || $(e.target).closest(".g-popup__close").length == 1)
                $popup.fadeOut(200);
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
            else if($(this).attr("name") == "email" && val != "" && !validateEmail(val))
                $(this).addClass("g-input_error");
        });
        $("#review-form").on("submit", function(e){
            e.preventDefault();
            var $form = $(this),
                $name_input = $form.find("input[name='name']"),
                name = $name_input.val(),
                $email_input = $form.find("input[name='email']"),
                email = $email_input.val(),
                $message_input = $form.find("textarea[name='message']"),
                message = $message_input.val(),
                error = false;
                if(name == ""){
                    $name_input.addClass("g-input_error");
                    error = true;
                }
                if(!validateEmail(email)){
                    $email_input.addClass("g-input_error");
                    error = true;
                }
                if(message == ""){
                    $message_input.addClass("g-input_error");
                    error = true;
                }
            console.log($("[name='rating']:checked").val());
            if(!error){
//                      $.ajax({
//                        data: $(this).serialize(),
//                        url: "",
//                        method: "POST",
//                        success: function(){
                            $name_input.val("");
                            $email_input.val("");
                            $message_input.val("");
                            $("[name='rating']:checked").prop("checked", false);
                            $("#success-review").fadeIn(200);
//                        }
//                    });                
            }
            return false;
        });
        if($("input[type='tel']").length > 0)
            $("input[type='tel']").inputmask("+9 (999) 999-99-99");
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

        } else if($("body").hasClass("registrations edit")){
            var $form = $("#personal-form");
            // $("#add-adress").on("click", function(){
            //     $form.find(".g-adress-block").append($("#adress-wrapper").find(".g-fieldset").clone());
            // });
            $("body").on("click", ".g-adress-remove", function(){
                // $(this).parent().remove();
                // Если мы ремувим, то не получается ставить чекбокс для удаления на тру, так
                // как чекбокса-то уже нет!
                // Див мы прячем и так в profile.js по клику на ссылку
            });

            $(".g-table__rating").each(function(){
                var val = $(this).data("val");
                for(var i = 1; i <= 5; i++)
                    $(this).append($("<i/>",{
                                        class: "i-star " + ((i <= val)? "" : "i-star_blank")
                                     }));
            });
            $(".js-estimate").on("click", function(){
                var $popup = $("#rating-popup");
                $popup.find("input[name='order_id']").val($(this).parents("tr").data("id"));
                $popup.find("#number").text($(this).parents("tr").find("td:nth-child(2)").text());
                $popup.find("#date").text($(this).parents("tr").find("td:nth-child(1)").text());
                showPopup($popup);
            });
            
            $("#rating_form").on("submit", function(e){
                e.preventDefault();
                var $rating_form = $(this);
//                      $.ajax({
//                        data: $(this).serialize(),
//                        url: "",
//                        method: "POST",
//                        success: function(){
                            var communication = $rating_form.find("input[name='communication']:checked").val(),
                                delivery = $rating_form.find("input[name='delivery']:checked").val(),
                                quality = $rating_form.find("input[name='quality']:checked").val(),
                                recipesrecipes = $rating_form.find("input[name='recipes']:checked").val(),
                                id = $rating_form.find("input[name='order_id']").val();
                
                            if(typeof communication == 'undefined') communication = 0;
                            if(typeof delivery == 'undefined') delivery = 0;
                            if(typeof quality == 'undefined') quality = 0;
                            if(typeof recipesrecipes == 'undefined') recipesrecipes = 0;
                
                            communication = parseFloat(communication);
                            delivery = parseFloat(delivery);
                            quality = parseFloat(quality);
                            recipesrecipes = parseFloat(recipesrecipes);
                            var sum = parseInt((communication + delivery + quality + recipesrecipes)/4),
                                $rating_td = $("#orders_table").find("tr[data-id=" + id + "] td:last-child");
                            $rating_td.html("");
                            for(var i = 1; i <= 5; i++)
                                $rating_td.append($("<i/>",{
                                        class: "i-star " + ((i <= sum)? "" : "i-star_blank")
                                     }));
                            
                            $("#rating-popup").fadeOut(300);
//                        }
//                    });          
                return false;
            });

            $(".js-personal-toggle").on("click", function(){
                var id = $(this).data("id"),
                    $container = $("#personal-wrapper");
                if($container.find("#"+id+":visible").length > 0) return false;
                $(this).parent().find(".js-personal-toggle").removeClass("g-menu-toggle__var_active");
                $(this).addClass("g-menu-toggle__var_active");
                $container.find(".g-personal-block").fadeOut(100,function(){
                    $container.find("#"+id).fadeIn(300);
                });
                
            });

          }
        else if($("body").hasClass("home")){
            $(".g-week-menu__list[data-type=" + $(".g-menu-block").data("view") + "]").fadeIn(300);
            // ПОКА временный хак
            $('*[data-type="2"]').css({ display: "none"})
            // Хак
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
            } else if($("body").hasClass("orders new")){
            var $form = $("#checkout-form");
            if($form.find("[name='is-exist']").val() == "true"){
                $(".g-select").select2();
                $(".js-add-adress").hide();
                $("#adress_select").on("change",function(){
                    if($(this).val() == "new")
                        $(".js-add-adress").fadeIn(300);
                    else
                        $(".js-add-adress, #region").fadeOut(100);
                });
            }
            $(".js-show-region").on("change", function(){
                if($(this).val() == 'true')
                    $form.find("#region").fadeIn(300);
                else
                    $form.find("#region").fadeOut(300).find("input").val("")
            });
            $(".js-input_number").inputmask("9{1,4}");
            
            $form.on("submit", function(e){
                e.preventDefault();
                
                $("input[name=commit]").val("Оформляем...");

                var $name_input = $form.find("[name='order[first_name]']"),
                    name = $name_input.val(),
                    $email_input = $form.find("[name='order[email]']"),
                    email = $email_input.val(),
                    $lastname_input = $form.find("[name='order[second_name]']"),
                    lastname = $lastname_input.val(),
                    $phone_input = $form.find("[name='order[phone]']"),
                    phone = $phone_input.val().replace(/\D+/g,""),
                    $street_input = $form.find("[name='order[street]']"),
                    street = $street_input.val(),
                    $house_input = $form.find("[name='order[house]']"),
                    house = $house_input.val(),
                    is_region = $form.find("[name='order[delivery_region]']:checked").val() == "true",
                    $city_input = $form.find("[name='order[city]']"),
                    city = $city_input.val(),
                    error = false;
                
                if($form.find("[name='is-exist']").val() == "true"){
                    if($form.find("#adress_select").val() == "new"){
                        if(is_region && city == ""){
                            $city_input.addClass("g-input_error");
                            error = true;
                        }
                        if(street == ""){
                            $street_input.addClass("g-input_error");
                            error = true;
                        }
                        if(house == ""){
                            $house_input.addClass("g-input_error");
                            error = true;
                        }                       
                    }
                } else {
                    if(name == ""){
                        $name_input.addClass("g-input_error");
                        error = true;
                    }
                    if(!validateEmail(email)){
                        $email_input.addClass("g-input_error");
                        error = true;
                    }
                    if(is_region && city == ""){
                        $city_input.addClass("g-input_error");
                        error = true;
                    }
                    if(street == ""){
                        $street_input.addClass("g-input_error");
                        error = true;
                    }
                    if(house == ""){
                        $house_input.addClass("g-input_error");
                        error = true;
                    }
                    if(phone.length < 11){
                        $phone_input.addClass("g-input_error");
                        error = true;
                    }
                    
                }

                if (error){
                  $("input[name=commit]").val("Ошибки...");
                }
                if(!error){
                  $("input[name=commit]").val("Оформляем...");
                     $.ajax({
                       data: $(this).serialize(),
                       url: "/orders",
                       method: "POST",
                       success: function(response){
                            // location.href = "success.html";
                            // console.log(eval(response));

                       }
                   });
                }                  
                return false;
            });
        } else if($("body").hasClass("dinner")){
            $(".m-menu-items__list[data-type=" + $(".g-menu-block").data("show") + "]").fadeIn(300);
            $("#sms-form").on("submit", function(e){
                e.preventDefault();
                var error = false,
                    $pass = $(this).find("#sms-pass"),
                    val = $pass.val();
                if(val == ""){
                    $pass.addClass("g-input_error");
                    error = true;
                }
                
                if(!error){
                     // $.ajax({
                     //   data: $(this).serialize(),
                     //   url: "/something",
                     //   method: "GET",
                     //   success: function(){
                            $pass.val("");
                            $(".g-popup-wrapper").fadeOut(200);
                   //     }
                   // });
                }
                return false;  
            });
            $("#menu-form").on("submit", function(e){
                e.preventDefault();
                var error = false,
                    $phone = $(this).find("#phone-input"),
                    val = $phone.val().replace(/\D+/g,"");
                if(val.length < 11){
                    $phone.addClass("g-input_error");
                    error = true;
                }
                if(!error){
                   $.ajax({
                       data: $(this).serialize(),
                       url: "/process_order",
                       method: "GET",
                       success: function(){
                            $phone.val("");
                            showPopup($("#send-popup"));        
                       }
                   });
                    
                }
                
                return false;
            });
            
            var $menu_node = $(".g-menu-block");
            
            function calculate(menu_toggle){
              var current_type = $menu_node.data("show"),
                    $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
                var price_changes = [];
                $current_list.data("price-changes").split("|").forEach(function(e,i){
                    var reg = new RegExp(/^(\d*)\{([\d\:\,]*)\}/),
                        res = e.match(reg),
                        object = {
                            person: res[1],
                            changes: [],
                            counts: []
                        };
                    res[2].split(",").forEach(function(num,i){
                        object.changes.push(parseInt(num.split(":")[1]));
                        object.counts.push(num.split(":")[0]);
                    });
                    price_changes.push(object);
                });
              if(menu_toggle){
                        $menu_node.find("#menu-id").val(current_type);
                var $counts_node = $menu_node.find("#dinner_counts").html(""),
                        $persons_count = $menu_node.find("#persons_count").html(""),
                        $dessert_node = $menu_node.find("#has-dessert").html(""),
                  has_dessert = $current_list.data("hasdessert");
                  price_changes[0].counts.forEach(function(num, index){
                    $("<input/>",{
                      class: "js-menu-input m-menu-form__hide",
                      value: num,
                      id: "quantity_" + num,
                      type: "radio",
                      name: "quantity"
                    }).prop("checked", 0 == index).appendTo($counts_node);
                    $("<label/>",{
                      for: "quantity_" + num,
                    class: "m-menu-form__radio",
                    text: (index == 0)? all_text + number_text[num - 1]: number_text[num - 1]
                    }).appendTo($counts_node);
                  });
                        price_changes.forEach(function(num,index){
                            $("<input/>",{
                                class: "js-menu-input m-menu-form__hide",
                                type: "radio",
                                name: "people",
                                value: num.person,
                                id: "people_" + num.person
                           }).prop("checked", 0 == index).appendTo($persons_count);
                            $("<label/>",{
                                for: "people_" + num.person,
                                class: "m-menu-form__radio",
                                text: persons_text[num.person - 1]
                            }).appendTo($persons_count);
                        });
                        if(has_dessert){
                            $("<input/>",{
                                type: "checkbox",
                                name: "dessert",
                                id: "dessert",
                                class: "js-menu-input g-checkbox m-menu-form__hide"
                            }).appendTo($dessert_node);
                            $("<label/>",{
                                for: "dessert",
                                class: "g-checkbox-label m-menu-form__checkbox",
                                text: "Добавить десерт"
                            }).appendTo($dessert_node);
                        }
                        $menu_node.find("#date").text($current_list.data("date"));
              }
                var $eat = $current_list.find(".m-menu-items__item[data-product='eat']"),
                    $dessert = $current_list.find(".m-menu-items__item[data-product='dessert']"),
                    quantity = $menu_node.find("input[name=quantity]:checked").val(),
                    quantity_index,
                    person = $menu_node.find("input[name=people]:checked").val(),
                    dessert = $menu_node.find("input[name=dessert]:checked").val(),
                    total_price = 0,
                    current_person;
                price_changes.forEach(function(el,i){
                    if(person == el.person)
                        current_person = i;
                });
                quantity_index = price_changes[current_person].counts.indexOf(quantity);
                
                $eat.removeClass("m-menu-items__item_disabled").each(function(i, el){
                    var $el = $(el);
                    if($el.data("package") > quantity[0])
                        $el.addClass("m-menu-items__item_disabled");
                });
                $dessert.removeClass("m-menu-items__item_disabled");
                if(typeof dessert == 'undefined')
                    $dessert.addClass("m-menu-items__item_disabled");
                else
                    total_price += parseInt($dessert.data("price"));
                total_price += parseInt($current_list.data("price")) + price_changes[current_person].changes[quantity_index];
                $menu_node.find("#total_price").text(total_price);
            }
            
            calculate(true);
            $(".js-main-menu").on("click", function(e){
                e.preventDefault();
                if($(this).data("var") == $menu_node.data("view")) return false;
                $menu_node.data("show", $(this).data("var")).find("[data-type]").hide().filter("[data-type='"+$(this).data("var")+"']").fadeIn(500);
                $menu_node.find(".g-menu-toggle__var").removeClass("g-menu-toggle__var_active");
                $(this).addClass("g-menu-toggle__var_active");
                calculate(true);
                return false;
            });
            $menu_node.on("change", ".js-menu-input", function(){
              calculate();
            });
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