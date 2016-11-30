
// Init owl carousel
var team_carousel = $("#owl-team");

  team_carousel.owlCarousel({
    margin:10,
    loop:true,
    autoWidth:true,
    items:1,
    navigation:true,
    navigationText: [
      "<i class='fa fa-chevron-left no-class-icon'></i>",
      "<i class='fa fa-chevron-right no-class-icon'></i>"
      ],
  });