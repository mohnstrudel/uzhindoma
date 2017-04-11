(function($){
    $(document).ready(function(){
        if($("body").hasClass("h-body")){
            mapboxgl.accessToken = 'pk.eyJ1Ijoic2NobmliYmEiLCJhIjoiMWEwYWI4YTA3YTAwYjVhYTY1YWZiZGFiZDk1Zjk5NGUifQ.ueMMb8kMdWxrP5N4iqx67Q';
            var map = new mapboxgl.Map({
                container: 'h-map',
                style: 'mapbox://styles/schnibba/ciw9f6qp500542qmkzdjjqd8o',
                center: [37.5689484, 55.7491617],
                zoom: 7.5,
                hash: false,
                interactive: false
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